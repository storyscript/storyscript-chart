# deploy
yaml = helm(
  '.',
  name='storyscript',
  namespace='asyncy-system',
  set=[
    'hello-world.enabled=true',
    'database.image=storyscript/database',
    'gateway.image=asyncy/http',
    'graphql.image=asyncy/platform-graphql',
    'runtime.image=asyncy/platform-engine-prod',
    'synapse.image=asyncy/platform-synapse',
  ]
)
k8s_yaml(yaml)

# build
docker_build('storyscript/database', '../database')
docker_build('asyncy/http', '../http')
docker_build('asyncy/platform-graphql', '../platform-graphql')
docker_build('asyncy/platform-engine-prod', '../runtime')
docker_build('asyncy/platform-synapse', '../platform-synapse')
