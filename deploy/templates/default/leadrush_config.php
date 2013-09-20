<?php
class LeadrushDB {
  public $adapter, $database, $encoding, $host, $username, $password, $reconnect;

  public function __construct() {
    $this->adapter = '<%= @database[:adapter] %>';
    $this->database = '<%= @database[:database] %>';
    $this->encoding = 'utf8';
    $this->host = '<%= @database[:host] %>';
    $this->username = '<%= @database[:username] %>';
    $this->password = '<%= @database[:password] %>';
    $this->reconnect = '<%= @database[:reconnect] ? 'true' : 'false' %>';
  }
}

class LeadrushMemcached {
  public $host, $port;

  public function __construct() {
    $this->host = '<%= @memcached[:host] %>';
    $this->port = '<%= @memcached[:port] %>';
  }
}

class LeadrushAPP {
  public $db;
  public $memcached;
  private $stack_map;

  public function __construct() {
    $this->db = new LeadrushDB();
    $this->memcached = new LeadrushMemcached();
    $this->stack_map = array(<%= @layers.map {|layer_short_name, layer| "'#{layer_short_name}' => array(#{layer['instances'].values.map {|instance| "'#{instance['private_ip']}'"}.join(', ') })"}.join(', ') %>);
    $this->stack_name = '<%= @stack_name %>';
    $this->revision = '<%= @revision %>';
  }

  public function layers() {
    return array_keys($this->stack_map);
  }

  public function hosts($layer) {
    return $this->stack_map[$layer];
  }
}