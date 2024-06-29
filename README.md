![alt text](image.png)

### Terraform, Proxmox, Ansible e Docker

Nesse lab usei o terraform para provisionar o um LXC no Proxmox e com o Ansible instalei o Docker, essa pode ser uma boa base para o seu projeto.

### Pré requisitos
1. Necessario o terraform instalado na sua maquina.
2. Necessario o ansible instalado na sua maquina.
3. Precisa do sshpass instalado.

### Como ultilizar
```bash
terraform init
terraform plan -out=plan 
terraform apply "plan"
terraform output -json | jq -r '.root_password.value'
```

Testado em MacOs e Linux ubuntu.