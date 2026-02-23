/**
 * Lambda Authorizer para API Gateway (HTTP API o REST API).
 * Valida JWT y consulta bd_tenancy_planes para permitir o denegar (empresa activa).
 * Compatible con API Gateway HTTP API (response v2).
 */

import jwt from 'jsonwebtoken';
import mysql from 'mysql2/promise';
import { SecretsManagerClient, GetSecretValueCommand } from '@aws-sdk/client-secrets-manager';

const REGION = process.env.AWS_REGION || 'us-east-1';
const SECRET_ARN = process.env.SECRET_ARN; // ARN del secret con JWT_SECRET y opcionalmente DB_*
const TENANCY_DB_NAME = process.env.TENANCY_DB_NAME || 'bd_tenancy_planes';

const secretsClient = new SecretsManagerClient({ region: REGION });
let cachedSecrets = null;
let cachedAt = 0;
const CACHE_TTL_MS = 5 * 60 * 1000; // 5 min

async function getSecrets() {
  if (cachedSecrets && Date.now() - cachedAt < CACHE_TTL_MS) {
    return cachedSecrets;
  }
  if (!SECRET_ARN) {
    throw new Error('SECRET_ARN not set');
  }
  const res = await secretsClient.send(
    new GetSecretValueCommand({ SecretId: SECRET_ARN })
  );
  const raw = res.SecretString;
  cachedSecrets = JSON.parse(raw);
  cachedAt = Date.now();
  return cachedSecrets;
}

function getTokenFromEvent(event) {
  const auth = event.headers?.authorization || event.headers?.Authorization;
  if (auth && auth.startsWith('Bearer ')) {
    return auth.slice(7);
  }
  return null;
}

/**
 * Consulta si la empresa está activa (estado_pago y vigente_hasta).
 * Usa ten_planes_empresas; estado_pago 1 = al día; vigente_hasta >= hoy.
 */
async function isEmpresaActiva(connection, idEmpresa) {
  const [rows] = await connection.execute(
    `SELECT estado_pago, vigente_hasta
     FROM ten_planes_empresas
     WHERE id_empresa = ? AND estado = 1
     ORDER BY id_llave DESC LIMIT 1`,
    [idEmpresa]
  );
  if (!rows || rows.length === 0) {
    return false;
  }
  const { estado_pago, vigente_hasta } = rows[0];
  // 1 = al día; 2 = vencido; 3 = suspendido; 4 = cancelado
  if (estado_pago !== 1 && estado_pago !== '1') {
    return false;
  }
  if (vigente_hasta) {
    const hoy = new Date().toISOString().slice(0, 10);
    const vigente = new Date(vigente_hasta).toISOString().slice(0, 10);
    if (vigente < hoy) {
      return false;
    }
  }
  return true;
}

/**
 * Handler para API Gateway HTTP API (payload format v2).
 * Respuesta: { isAuthorized: boolean, context?: { id_empresa: string, ... } }
 */
export async function handler(event) {
  const token = getTokenFromEvent(event);
  if (!token) {
    return {
      isAuthorized: false,
      context: { reason: 'missing_token' },
    };
  }

  let secrets;
  try {
    secrets = await getSecrets();
  } catch (e) {
    console.error('getSecrets failed', e);
    return { isAuthorized: false, context: { reason: 'config_error' } };
  }

  const jwtSecret = secrets.JWT_SECRET;
  if (!jwtSecret) {
    console.error('JWT_SECRET missing in secret');
    return { isAuthorized: false, context: { reason: 'config_error' } };
  }

  let decoded;
  try {
    decoded = jwt.verify(token, jwtSecret, { algorithms: ['HS256'] });
  } catch (e) {
    return {
      isAuthorized: false,
      context: { reason: 'invalid_token' },
    };
  }

  const idEmpresa = decoded.id_empresa ?? decoded.sub;
  if (idEmpresa == null) {
    return { isAuthorized: false, context: { reason: 'missing_id_empresa' } };
  }

  // Opción A: Lambda tiene acceso a RDS (Lambda en VPC con mysql2)
  const dbHost = secrets.DB_HOST || process.env.DB_HOST;
  if (dbHost) {
    let connection;
    try {
      connection = await mysql.createConnection({
        host: dbHost,
        user: secrets.DB_USER || process.env.DB_USER,
        password: secrets.DB_PASSWORD || process.env.DB_PASSWORD,
        database: secrets.DB_NAME || TENANCY_DB_NAME,
        port: secrets.DB_PORT || process.env.DB_PORT || 3306,
      });
      const activa = await isEmpresaActiva(connection, idEmpresa);
      await connection.end();
      if (!activa) {
        return {
          isAuthorized: false,
          context: { reason: 'empresa_suspendida', id_empresa: String(idEmpresa) },
        };
      }
    } catch (e) {
      console.error('DB check failed', e);
      return { isAuthorized: false, context: { reason: 'tenancy_check_error' } };
    }
  }
  // Opción B: Sin RDS en Lambda; confiar en JWT y que otro servicio valide tenancy (id_empresa se reenvía igual)

  return {
    isAuthorized: true,
    context: {
      id_empresa: String(idEmpresa),
      numero_documento: decoded.numero_documento ?? decoded.sub ?? '',
    },
  };
}
