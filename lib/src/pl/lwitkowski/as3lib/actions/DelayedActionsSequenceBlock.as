package pl.lwitkowski.as3lib.actions 
{
	import pl.lwitkowski.as3lib.actions.scripting.ScriptParser;
	
	/**
	 * @author lwitkowski
	 */
	public class DelayedActionsSequenceBlock extends ActionsSequenceBlock 
	{		
		private var _parser:ScriptParser;
		private var _script : String;
		private var _group : String = null;
		
		public function DelayedActionsSequenceBlock(parser:ScriptParser, script:String, group:String = null) {
			super();
			_parser = parser;
			_script = script;
			_group = group;			
		}
		
		override public function execute():void {

			pushActions(_parser.parseScript(_script, _group));
            trace();
			super.execute();
		}

        public function get actions():Vector.<IAction> {

            return _parser.parseScript(_script, _group);
        }
	}
}
