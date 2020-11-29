local exercism_projects = std.map(function(x) std.strReplace(x, '/', ''), std.split(std.extVar('exercism_projects'), '\n'));
local lang = std.extVar('lang');

local ElixirTestJob(name) = {
  ['.' + lang + '-' + name + '-gitlab-ci.yml']: {
    default: {
      image: 'elixir:latest',
    },
    ['test-' + lang + '-' + name + '-exercism']: {
      script: [
        'cd ' + name,
        'test -f mix.exs && mix test || elixir *_test.exs',
      ],
    },
  },
};


std.foldl(function(x, y) x + y, std.map(ElixirTestJob, exercism_projects), {})
