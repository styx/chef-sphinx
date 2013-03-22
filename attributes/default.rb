default[:sphinx][:install_path] = "/usr/local"
default[:sphinx][:version]      = '2.0.6-release'
default[:sphinx][:url]          = "http://sphinxsearch.com/files/sphinx-#{sphinx[:version]}.tar.gz"
default[:sphinx][:checksum]     = "de943c397efda706661b3a12e12e9f8cc8a03bf6c02c5a6ba967a06384feede2"
default[:stemmer][:url]         = "http://snowball.tartarus.org/dist/libstemmer_c.tgz"
default[:stemmer][:checksum]    = "3cd570d3d7917fc01449ef3199d78a738a2f213d75581331b81608e059ea10a8"

default[:sphinx][:use_postgres] = true
default[:sphinx][:use_mysql]    = false
default[:sphinx][:use_stemmer]  = false

default[:sphinx][:configure_flags] = [
  "#{sphinx[:use_postgres] ? '--with-pgsql'   : '--without-pgsql'}",
  "#{sphinx[:use_mysql]    ? '--with-mysql'   : '--without-mysql'}",
  "#{sphinx[:use_stemmer]  ? '--with-stemmer' : '--without-stemmer'}"
]


