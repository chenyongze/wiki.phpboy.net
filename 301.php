<?php
if(!defined('DOKU_INC')) define('DOKU_INC',dirname(__FILE__) . '/');
require_once(DOKU_INC.'inc/init.php');

if (!empty($_REQUEST['url'])) {
    $uri  = $_REQUEST['url'];
    $res  = preg_match('#(\d{4}-\d{2}/\d+)#', $uri, $post);
    if ($res) {
        $post = str_replace('/', ':', $post[1]);
        search($data, $conf['datadir'], 'search_allpages', array('ns' => $ns));

        foreach ($data as $k => $article) {
            if (strpos($article['id'], $post) !== false) {
                header('location: http://' . $_SERVER['HTTP_HOST'] . '/doku.php?id=' . $article['id']);
                break;
            }
        }
    } else {
        header('location: http://' . $_SERVER['HTTP_HOST'] . '/doku.php?id=首页');
    }
} else {
    header('location: http://' . $_SERVER['HTTP_HOST'] . '/doku.php?id=首页');
}