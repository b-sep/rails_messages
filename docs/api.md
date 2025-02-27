### **Todas as requisições exceto a requisição de login (criação de uma session) devem conter o header `Authorization` com o valor `Bearer token`!!**

## Login

`POST /api/session`

### Payload

```json
{
    "email_address": "user@example.com"
}
```

### Sucesso

Retorna status `201` com o seguinte json:

```json
{
    "user_name": "Example",
    "user_id": 1,
    "token": "token"
}
```

### Falha

Retorna status `401`

## Logout

`DELETE /api/session`

### Sucesso

Retorna status `204`

## Criação de Mensagens

`POST /messages`

### Payload

```json
{
    "message": {
        "recipient": "user@example.com",
        "content": "Now sending with another user x)"
    }
}
```

### Sucesso

Retorna status `200` após **agendar** um job.

### Falha

Retorna status `400` caso algum parâmetro esteja faltando.

Retorna status `401` quando o usuário não esta logado.

## Listagem de Mensagens

`GET /api/messages/:id`

### Sucesso

Retorna status `200` com um json com as mensagens do usuário:

```json
{
    "messages": {
        "sended_messages": [
            {
                "content": "Hello, from insomnia :)",
                "sended_at": "February 21, 2025 09:52",
                "to": "Example 2"
            }
        ],
        "received_messages": [
            {
                "content": "Hello, from insomnia :)",
                "from": "Example 2",
                "received_at": "February 21, 2025 09:55"
            }
        ]
    }
}
```

### Falha

- Retorna status `404` se o usuário não for encontrado
- Retorna status `401` se o usuário for diferente do usuário logado
