# Criação dos recursos Azure para ambiente App Services compartilhado

## Login na Azure
Antes de tudo efetue o login na conta da AZ com permissão para criação dos recursos:
```console
$ az login
```

## Para apontar para o ambiente correto
```console
$ terraform init -backend-config=<env_config_file> -migrate-state
```
Os arquivos de config de ambiente ficam na raiz do projeto.

Ao executar a alteracao sera exibida uma pergunta, responda "no".

Exemplo para ambiente DEV:
```console
$ terraform init -backend-config=config.dev.tfbackend -migrate-state
```

## Para criar / atualizar resource group e todos os recursos
```console
$ terraform apply -var-file=<vars_config_file>
```
Os arquivos de variaveis de ambiente ficam na raiz do projeto.

Exemplo para ambiente DEV:
```console
$ terraform apply -var-file=config.dev.tfvars
```

## Para destruir resource group e todos os recursos
```console
$ terraform destroy -var-file=<vars_config_file>
```
