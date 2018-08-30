
# Logstash Configuration Testing

This repository shows how to use docker to rapidly iterate Logstash configuration files.

It runs the Elastic Logstash docker image using the configuration files defined in the `pipeline` folder
and is set to automatically reload configuration files.

The input filter is `http` and port 8080 is shared with the host, so test lines can be
sent from the docker host to Logstash with curl.

You can run the container with `make` or `./run.sh`

# Example

Terminal 1:

```
alex.mccormack@host:~/logstash_dev_env: make
docker run \
		-v /Users/alex.mccormack/logstash_dev_env/pipeline:/usr/share/logstash/pipeline/ \
		-e XPACK_MONITORING_ENABLED=false \
		-e CONFIG_RELOAD_AUTOMATIC=true \
		-p 8080:8080 \
		elastic/logstash:6.3.2
2018/08/22 06:59:06 Setting 'xpack.monitoring.enabled' from environment.
2018/08/22 06:59:06 Setting 'config.reload.automatic' from environment.
Sending Logstash's logs to /usr/share/logstash/logs which is now configured via log4j2.properties
[2018-08-22T06:59:31,531][INFO ][logstash.setting.writabledirectory] Creating directory {:setting=>"path.queue", :path=>"/usr/share/logstash/data/queue"}
[2018-08-22T06:59:31,548][INFO ][logstash.setting.writabledirectory] Creating directory {:setting=>"path.dead_letter_queue", :path=>"/usr/share/logstash/data/dead_letter_queue"}
[2018-08-22T06:59:32,654][INFO ][logstash.agent           ] No persistent UUID file found. Generating new UUID {:uuid=>"d7e37bbd-a298-4631-87eb-9e99fd5acf31", :path=>"/usr/share/logstash/data/uuid"}
[2018-08-22T06:59:33,511][INFO ][logstash.runner          ] Starting Logstash {"logstash.version"=>"6.3.2"}
[2018-08-22T06:59:37,743][INFO ][logstash.pipeline        ] Starting pipeline {:pipeline_id=>"main", "pipeline.workers"=>4, "pipeline.batch.size"=>125, "pipeline.batch.delay"=>50}
[2018-08-22T06:59:38,082][INFO ][logstash.pipeline        ] Pipeline started successfully {:pipeline_id=>"main", :thread=>"#<Thread:0x5bc74490 run>"}
[2018-08-22T06:59:38,247][INFO ][logstash.agent           ] Pipelines running {:count=>1, :running_pipelines=>[:main], :non_running_pipelines=>[]}
[2018-08-22T06:59:38,685][INFO ][logstash.agent           ] Successfully started Logstash API endpoint {:port=>9600}
{
     "message" => "hello world",
    "@version" => "1"
}
{
     "message" => "literal text",
    "@version" => "1"
}
```

Logstash can take about 30 seconds to load up. When you see `Pipeline started successfully`, Logstash is ready for events.

Terminal 2:

```
alex.mccormack@host:~: echo "hello world" > /tmp/test.txt
alex.mccormack@host:~: curl --data @/tmp/test.txt -w "\n" http://127.0.0.1:8080
ok
alex.mccormack@host:~: curl --data 'literal text' -w "\n" http://127.0.0.1:8080
ok
```
