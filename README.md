<h1 align="center">
   MS-Infrastructure 
</h1>

<h4 align="center"> 
	🚧  MS-Infrastructure  🚧 MVP concluído ... 🚧 🚀
</h4>

<p align="center">
 <a href="#-sobre-o-projeto">Sobre</a> •
 <a href="#-funcionalidades">Funcionalidades</a> •
 <a href="#-como-executar">Como executar</a> •
  <a href="#-como-contribuir-para-o-projeto">Como contribuir para o projeto</a> •
</p>


## 💻 Sobre o projeto

MS-Infrastructure em .NET 8. Projeto que compõe o serviço de eccomerce desenvolvido no trabalho de conclusão de curso da pós tech da FIAP.

---

## ⚙️ Funcionalidades

- [x] Criação de task definitions para 5 serviços;
- [x] Criação de application load balancer;
- [x] Criação de target groups com conditions para 5 serviços;
- [x] Criação de um cluster no ecs;
- [x] Criação dos serviços no ecs e ligação com o alb através do target group.

---

## 💻 Como executar

- Pré requisitos
  - Terraform;
  - Aws credentials configurado;

- Clone o projeto com: `git clone https://github.com/mhme2000/MS-Products.git`
- Acesse o projeto, e execute: `terraform apply`
- Pronto! Agora sua infra será deployada para aws, é só se divertir!
PS: Alguns ids devem ser alterados para os dados da sua conta como: vpc-id, subnet-id, etc...
---

## 💪 Como contribuir para o projeto

1. Faça um **fork** do projeto.
2. Crie uma nova branch com as suas alterações: `git checkout -b my-feature`
3. Salve as alterações e crie uma mensagem de commit contando o que você fez: `git commit -m "feature: My new feature"`
4. Envie as suas alterações: `git push origin my-feature`
---

Feito com ❤️ por Marcos Eckart 👋🏽 [Entre em contato!](https://www.linkedin.com/in/marcos-eckart/)

---
