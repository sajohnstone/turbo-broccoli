# turbo-broccoli

This is a example project using a Lambda, S3 and API Gateway to provide a basic REST endpoint.  I should point out that I'm not
generally a Node developer, but I need something that would be 'lite' enought to use for a Lambda and always enjoy a challange.
The purpose of this project is to generate the timezone from a given list of device Ids.  Currently it's not fetching the timezone
mainly as I couldn't find anywhere that will do the conversion without the API key of some kind.  However that was my proposed method
and a simple API call would have given that result.

## Getting started

Before getting started you will need:-

- Teraform
- Node
- AWS Cli

To deploy do the following:-

```bash
make deploy
```

This will deploy to your AWS env as setup in the AWS CLI.  It should also output an endpoint which can be used for testing or you can 
test using the AWS console.

## Adherence to best practices

Within this project have tried to fit with a number of four main principles:-

- Apply least privilege (resources only have access to what they need)
- Minimise the attack surface (API gateway is only entrypoint)
- Layer the security measures to achieve defence in depth (in this case there aren't too many resources, but it was considered)
- Encrypt everything (I haven't for simplicy but would normally)

For the Lambda itself I've tried to stick with:

- [TDD approach](https://en.wikipedia.org/wiki/Test-driven_development)
- [SOLID principles](https://en.wikipedia.org/wiki/SOLID)
- [Clean code](https://en.wikipedia.org/wiki/Robert_C._Martin)

## Assumptions

These are some of the assuptions I've taken:-

- Persistence in S3 in temporary, but the simplest thing to do in the absence of any further requirement
- Observability more thought would need to be given to this
- For a larger project I'd organise my TF files into modules, but it doesn't make sense here
- Optimize the lambda by using something like Webpack
- Add in static code analysis
- To avoid having to create lambda layers I've kept the code simple with no dependancies

## CI

I haven't included a CI pipeline in this, but would consider something like [Travis](https://travis-ci.org/getting_started) as a simple solution doing this.
