<?php
/**
 * DokuWiki Plugin duoshuo (Syntax Component)
 *
 * @license GPL 2 http://www.gnu.org/licenses/gpl-2.0.html
 * @author  Matt <caijiamx@gmail.com>
 */

// must be run within Dokuwiki
if (!defined('DOKU_INC')) die();

class syntax_plugin_duoshuo extends DokuWiki_Syntax_Plugin {
    const DUOSHUO_SYNTAX = "~~DUOSHUO~~";
    const NODUOSHUO_SYNTAX = "~~NODUOSHUO~~";
    /**
     * @return string Syntax mode type
     */
    public function getType() {
        return 'substition';
    }
    /**
     * @return string Paragraph type
     */
    public function getPType() {
        return 'block';
    }
    /**
     * @return int Sort order - Low numbers go before high numbers
     */
    public function getSort() {
        return 160;
    }

    /**
     * Connect lookup pattern to lexer.
     *
     * @param string $mode Parser mode
     */
    public function connectTo($mode) {
        $this->Lexer->addSpecialPattern(self::DUOSHUO_SYNTAX,$mode,'plugin_duoshuo');
        $this->Lexer->addSpecialPattern(self::NODUOSHUO_SYNTAX,$mode,'plugin_duoshuo');
    }

    /**
     * Handle matches of the duoshuo syntax
     *
     * @param string $match The match of the syntax
     * @param int    $state The state of the handler
     * @param int    $pos The position in the document
     * @param Doku_Handler    $handler The handler
     * @return array Data for the renderer
     */
    public function handle($match, $state, $pos, &$handler){
        $match = preg_replace( '/~~/' , '' , $match );
        return array(strtolower($match));;
    }

    /**
     * Render xhtml output or metadata
     *
     * @param string         $mode      Renderer mode (supported modes: xhtml)
     * @param Doku_Renderer  $renderer  The renderer
     * @param array          $data      The data from the handler() function
     * @return bool If rendering was successful.
     */
    public function render($mode, &$renderer, $data) {
        if($mode != 'xhtml') return false;
        if($data[0] == "duoshuo"){
            $renderer->doc .= $this->getDuoshuoScript();
        }
        return true;
    }

    public function getDuoshuoScript(){
        $short_name = $this->getConf('shortname');
        $wiki_id  = getID();
        $wiki_title = tpl_pagetitle($wiki_id , true);
        $host = $_SERVER['HTTPS']?"https":"http";
        $host = $host . "://" . $_SERVER['SERVER_NAME'];
        $wiki_url = $host . wl($wiki_id);
        $doc = '
        <!-- 多说评论框 start -->
    <div class="ds-thread" data-thread-key="" data-title="' . $wiki_title . '" data-url="' . $wiki_url . '"></div>
<!-- 多说评论框 end -->
<!-- 多说公共JS代码 start (一个网页只需插入一次) -->
<script type="text/javascript">
var duoshuoQuery = {short_name:"' . $short_name . '"};
    (function() {
        var ds = document.createElement("script");
        ds.type = "text/javascript";ds.async = true;
        ds.src = (document.location.protocol == "https:" ? "https:" : "http:") + "//static.duoshuo.com/embed.js";
        ds.charset = "UTF-8";
        (document.getElementsByTagName("head")[0] 
         || document.getElementsByTagName("body")[0]).appendChild(ds);
    })();
    </script>
<!-- 多说公共JS代码 end -->';
        return $doc;
    }
}

// vim:ts=4:sw=4:et:
