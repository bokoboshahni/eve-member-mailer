FROM ledermann/rails-base-builder:3.0.1-alpine as Builder

RUN rm -f .browserslistrc .editorconfig .env .env.example .eslintignore .eslintrc.json .gitattributes .gitignore .node-version .prettierignore .prettierrc .rspec .rubocop.yml .ruby-version babel.config.js package.json stylelint.config.js tsconfig.json yarn.lock

FROM ledermann/rails-base-final:3.0.1-alpine
LABEL maintainer="shahni@bokobo.space"

COPY --from=Builder /etc/alpine-release /tmp/dummy

USER app

CMD ["docker/startup.sh"]
