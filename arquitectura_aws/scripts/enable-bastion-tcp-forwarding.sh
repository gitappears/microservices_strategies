#!/bin/bash
# Habilita AllowTcpForwarding en el bastión para permitir túneles SSH (-L).
# Ejecutar UNA VEZ en el bastión (vía SSH):
#   scp -i arquitectura_aws/qinspecting-bastion.pem scripts/enable-bastion-tcp-forwarding.sh ec2-user@<IP_BASTION>:~
#   ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@<IP_BASTION> 'sudo bash ~/enable-bastion-tcp-forwarding.sh'
set -e
echo "Configurando AllowTcpForwarding yes en /etc/ssh/sshd_config..."
if grep -q '^AllowTcpForwarding' /etc/ssh/sshd_config; then
  sed -i 's/^AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
else
  sed -i 's/^#*AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
  grep -q '^AllowTcpForwarding' /etc/ssh/sshd_config || echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config
fi
echo "Reiniciando sshd..."
systemctl restart sshd
echo "Listo. Ya puedes usar el túnel (-L 3306:...) desde tu PC."
