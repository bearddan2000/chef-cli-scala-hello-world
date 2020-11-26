FROM ubuntu:latest

WORKDIR /usr/local

COPY bin/* ./

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y chef git \
    && git clone https://github.com/bearddan2000/chef-lib-recipes.git \
    && chmod -R +x chef-lib-recipes \
    && mkdir -p cookbooks/op/recipes \
    && mv chef-lib-recipes/lang/scala.rb cookbooks/op/recipes/default.rb \
    && chef-solo -c chef-lib-recipes/solo.rb -o 'recipe[op]'

RUN chmod +x ./ScalaMain.scala \
    && scalac ./ScalaMain.scala \
    && chmod +x ./ScalaMain.class

CMD ["scala", "-classpath", "./", "ScalaMain"]
