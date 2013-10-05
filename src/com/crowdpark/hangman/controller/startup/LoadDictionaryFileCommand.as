/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 2:06 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.startup {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.controller.game.AbstractGameCommand;

import flash.display.Loader;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.puremvc.as3.multicore.interfaces.INotification;

public class LoadDictionaryFileCommand extends AbstractGameCommand {

    private var _loader:URLLoader = new URLLoader();

    public function LoadDictionaryFileCommand() {
        super();
    }


    override public function execute(notification:INotification):void {


        trace("load file");

        _loader.addEventListener(Event.COMPLETE, dictionaryFileLoadedHandler);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

        _loader.load(new URLRequest("resources/dictionary.txt"));
    }

    private function ioErrorHandler(event:IOErrorEvent):void {

        clearListeners();
        trace("loading dictionary file failed!");
    }

    private function dictionaryFileLoadedHandler(event:Event):void {

        var rawFile:String = _loader.data;
        gameProxy.dictionary = Vector.<String>(rawFile.split("\n"));

        clearListeners();

        executeCommand(StartupCompleteCommand);
    }

    private function clearListeners():void {

        _loader.removeEventListener(Event.COMPLETE, dictionaryFileLoadedHandler);
        _loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }
}
}
