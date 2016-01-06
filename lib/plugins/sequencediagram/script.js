/* DOKUWIKI:include_once scripts/underscore.js */
/* DOKUWIKI:include_once scripts/raphael.js */
/* DOKUWIKI:include_once scripts/grammar.js */
/* DOKUWIKI:include_once scripts/diagram.js */
/* DOKUWIKI:include_once scripts/jquery-plugin.js */
/* DOKUWIKI:include_once scripts/sequence-diagram.js */
/* DOKUWIKI:include_once scripts/flowchart.js */

jQuery(
	function(){
		jQuery(".diagram").sequenceDiagram({theme: 'simple'});
		jQuery(".flowchartdiagram").flowchart({
			// 'x': 30,
			// 'y': 50,
			'line-width': 2,
			'line-length': 30,
			'text-margin': 10,
			'font-size': 14,
			'font': 'normal',
			'font-family': 'Helvetica',
			'font-weight': 'normal',
			'font-color': 'black',
			'line-color': 'black',
			'element-color': 'black',
			'fill': '#f9f9f5',
			'yes-text': 'yes',
			'no-text': 'no',
			'arrow-end': 'block',
			'scale': 1,
			'symbols': {
				'start': {
					'element-color': 'green',
				},
				'end':{
					'class': 'end-element',
					'element-color': 'green',
				}
			},
		});
	}
);
