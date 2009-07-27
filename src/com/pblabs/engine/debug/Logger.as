/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.engine.debug
{
   import flash.events.EventDispatcher;
   
   import com.pblabs.engine.debug.log4PBE.Logger;
   
   /**
    * @eventType com.pblabs.engine.debug.LogEvent.ENTRY_ADDED_EVENT
    */
   [Event(name="ENTRY_ADDED_EVENT", type="com.pblabs.engine.debug.LogEvent")]
   
   /**
    * The Logger class provides mechanisms to print and listen for errors, warnings,
    * and general messages. The built in 'trace' command will output messages to the
    * console, but this allows you to differentiate between different types of
    * messages, give more detailed information about the origin of the message, and
    * listen for log events so they can be displayed in a UI component.
    * 
    * <p>To listen for new log events, subscribe to the ENTRY_ADDED_EVENT with the
    * addEventListener method. Callbacks for this event will receive a LogEvent.</p>
    * 
    * @see LogEvent
    * @see LogEntry
    */
   public class Logger extends EventDispatcher
   {
      /**
       * The singleton Logger instance.
       */
      public static function get instance():Logger
      {
         if (_instance == null)
            _instance = new Logger();
         
         return _instance;
      }
      
      /**
       * Prints a general message to the log. Log entries created with this method
       * will have the MESSAGE type.
       * 
       * @param reporter The object that reported the message. This can be null.
       * @param message The message to print to the log.
       */
      public static function print(reporter:*, message:String):void
      {
         var entry:LogEntry = new LogEntry();
         entry.reporter = reporter;
         entry.message = message;
         entry.type = LogEntry.MESSAGE;
         instance.addEntry(entry);
      }
      
      /**
       * Prints a general message to the log. Log entries created with this method
       * will have the MESSAGE type. This is the same as the Print method, with the
       * exception that the Push method is automatically called to indent subsequent
       * log messages.
       * 
       * @param reporter The object that reported the message. This can be null.
       * @param message The message to print to the log.
       * 
       * @see #Push()
       */
      public static function printHeader(reporter:*, message:String):void
      {
         print(reporter, message);
         push();
      }
      
      /**
       * Prints a general message to the log. Log entries created with this method
       * will have the MESSAGE type. This is the same as the Print method, with the
       * exception that the Pop method is automatically called to decrease the message
       * indent level.
       * 
       * @param reporter The object that reported the message. This can be null.
       * @param message The message to print to the log.
       * 
       * @see #Pop()
       */
      public static function printFooter(reporter:*, message:String):void
      {
         print(reporter, message);
         pop();
      }
      
      /**
       * Prints a warning message to the log. Log entries created with this method
       * will have the WARNING type.
       * 
       * @param reporter The object that reported the warning. This can be null.
       * @param method The name of the method that the warning was reported from.
       * @param message The warning to print to the log.
       */
      public static function printWarning(reporter:*, method:String, message:String):void
      {
         var entry:LogEntry = new LogEntry();
         entry.reporter = reporter;
         entry.method = method;
         entry.message = method + " - " + message;
         entry.type = LogEntry.WARNING;
         instance.addEntry(entry);
      }
      
      /**
       * Prints an error message to the log. Log entries created with this method
       * will have the ERROR type.
       * 
       * @param reporter The object that reported the error. This can be null.
       * @param method The name of the method that the error was reported from.
       * @param message The error to print to the log.
       */
      public static function printError(reporter:*, method:String, message:String):void
      {
         var entry:LogEntry = new LogEntry();
         entry.reporter = reporter;
         entry.method = method;
         entry.message = method + " - " + message;
         entry.type = LogEntry.ERROR;
         instance.addEntry(entry);
      }
      
      /**
       * Prints a message to the log. Log enthries created with this method will have
       * the type specified in the 'type' parameter.
       * 
       * @param reporter The object that reported the message. This can be null.
       * @param method The name of the method that the error was reported from.
       * @param message The message to print to the log.
       * @param type The custom type to give the message.
       */
      public static function printCustom(reporter:*, method:String, message:String, type:String):void
      {
         var entry:LogEntry = new LogEntry();
         entry.reporter = reporter;
         entry.method = method;
         entry.message = method + " - " + message;
         entry.type = type;
         instance.addEntry(entry);
      }
      
      /**
       * Utility function to get the current callstack. Only works in debug build.
       * Useful for noting who called what. Empty when in release build.
       */
      public static function getCallStack():String
      {
         try
         {
            var e:Error = new Error();
            return e.getStackTrace();
         }
         catch(e:Error)
         {
         }
         return "[no trace available]";
      }
      
      /**
       * Increases the depth of subsequent messages printed to the log. The depth can
       * be used to format the output of log entries by, for example, indenting messages
       * a number of times equal to their depth. In this way, messages that give more
       * detail about a previous message can be 'parented' to that message.
       * 
       * <p>Decrease the indent with the Pop method.</p>
       * 
       * @see #Pop()
       * @see #PrintHeader()
       */
      public static function push():void
      {
      }
      
      /**
       * Decreases the depth of subsequent messages printed to the log. This is the
       * inverse of the Push method.
       * 
       * @see #Push()
       * @see #PrintFooter()
       */
      public static function pop():void
      {
      }
      
      private static var _instance:Logger = new Logger();
      
      private function addEntry(entry:LogEntry):void
      {
         var reporter:* = entry.reporter ? entry.reporter : this;
         var logger:com.pblabs.engine.debug.log4PBE.Logger = com.pblabs.engine.debug.log4PBE.Logger.getLogger(reporter);
         
         var level:String = "Info";
         if (entry.type == LogEntry.ERROR)
            level = "Error";
         else if (entry.type == LogEntry.WARNING)
            level = "Warn";
         
         logger.log(level, entry.message);
      }
   }
}