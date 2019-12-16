# deploy
yaml = helm(
  '.',
  name='storyscript',
  set=[
    'database.image=storyscript/schema',
    'gateway.image=storyscript/gateway',
    'graphql.image=storyscript/graphql',
    'runtime.image=storyscript/runtime',
    'synapse.image=storyscript/synapse',
    'auth.image=storyscript/auth',
    'studio.image=storyscript/studio',
  ]
)
k8s_yaml(yaml)

# build
docker_build('storyscript/schema', '../schema')
docker_build('storyscript/gateway', '../http')
docker_build('storyscript/graphql', '../platform-graphql')
docker_build('storyscript/runtime', '../runtime')
docker_build('storyscript/synapse', '../platform-synapse')
docker_build('storyscript/auth', '../auth')
docker_build('storyscript/studio', '../studio', dockerfile='../studio/.docker/Dockerfile.docker')
