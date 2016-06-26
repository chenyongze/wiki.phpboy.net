<?php
/**
 * DokuWiki Plugin duoshuo (Action Component)
 *
 * @license GPL 2 http://www.gnu.org/licenses/gpl-2.0.html
 * @author  Matt <caijiamx@gmail.com>
 */

// must be run within Dokuwiki
if(!defined('DOKU_INC')) die();

class action_plugin_duoshuo extends DokuWiki_Action_Plugin {
    static $DUOSHUO = 0;
    /**
     * Registers a callback function for a given event
     *
     * @param Doku_Event_Handler $controller DokuWiki's event controller object
     * @return void
     */
    public function register(Doku_Event_Handler &$controller) {

       $controller->register_hook('PARSER_WIKITEXT_PREPROCESS', 'BEFORE', $this, 'handle_parser_wikitext_perprocess');
       $controller->register_hook('TPL_CONTENT_DISPLAY', 'BEFORE', $this, 'handle_tpl_content_display');
    }

    /**
     * [Custom event handler which performs action]
     *
     * @param Doku_Event $event  event object by reference
     * @param mixed      $param  [the parameters passed as fifth argument to register_hook() when this
     *                           handler was registered]
     * @return void
     */

    public function handle_parser_wikitext_perprocess(Doku_Event &$event, $param) {
        $flag = $this->_canShowDuoshuo($event->data);
        if($flag === 1 || $flag === 3){
            $event->data = preg_replace('/[^<nowiki>]' . syntax_plugin_duoshuo::DUOSHUO_SYNTAX . '/', '', $event->data);
        }
        return true;
    }

    public function handle_tpl_content_display(Doku_Event &$event, $param) {
        $flag = $this->_canShowDuoshuo($event->data);
        if($flag === 1){
            $event->data .= $this->getDuoshuoScript();
        }
        return true;
    }
    /**
     * check canshow duoshuo
     *
     * @param string $data  wikitest
     * @return bool 
     */
    private function _canShowDuoshuo($data){
        $flag = 0;
        $no_duoshuo = preg_match('/[^<nowiki>]' . syntax_plugin_duoshuo::NODUOSHUO_SYNTAX . '/' , $data , $matches);
        if($no_duoshuo >= 1 ||self::$DUOSHUO == 1){
            $flag = 3;
            self::$DUOSHUO = 1;
        }else{
            self::$DUOSHUO = 0;
            $auto = $this->getConf('auto');
            $no_admin = isset( $_REQUEST['do'] ) ? false : true ;
            $info = pageinfo();
            $exists = $info['exists'];
            if($auto){
                if($auto && $exists && $no_admin){
                    $flag = 1;
                }
            }else{
                $count = preg_match('/[^<nowiki>]' . syntax_plugin_duoshuo::DUOSHUO_SYNTAX . '/' , $data , $matches);
                if($count >= 1 && $exists && $no_admin){
                    $flag = 2;
                }
            }
        }
        return $flag;
    }

    public function getDuoshuoScript(){
        $syntax = new syntax_plugin_duoshuo();
        return $syntax->getDuoshuoScript();
    }
}

// vim:ts=4:sw=4:et:
