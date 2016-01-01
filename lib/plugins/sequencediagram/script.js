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
			'line-length': 40,
			'text-margin': 10,
			'font-size': 14,
			'font': 'normal',
			'font-family': 'Helvetica',
			'font-weight': 'normal',
			'font-color': 'black',
			'line-color': 'black',
			'element-color': 'black',
			'fill': 'white',
			'yes-text': 'yes',
			'no-text': 'no',
			'arrow-end': 'block',
			'scale': 1,
			'symbols': {
				'start': {
					'font-color': 'red',
					'element-color': 'green',
					'fill': 'yellow'
				},
				'end':{
					'class': 'end-element'
				}
			},
			'flowstate' : {
				'past' : { 'fill' : '#CCCCCC', 'font-size' : 12},
				'current' : {'fill' : 'yellow', 'font-color' : 'red', 'font-weight' : 'bold'},
				'future' : { 'fill' : '#FFFF99'},
				'request' : { 'fill' : 'blue'},
				'invalid': {'fill' : '#444444'},
				'approved' : { 'fill' : '#58C4A3', 'font-size' : 12, 'yes-text' : 'APPROVED', 'no-text' : 'n/a' },
				'rejected' : { 'fill' : '#C45879', 'font-size' : 12, 'yes-text' : 'n/a', 'no-text' : 'REJECTED' }
			}
		});
	}
);
