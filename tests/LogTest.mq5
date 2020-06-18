//+------------------------------------------------------------------+
//|                                                EA31337 framework |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @file
 * Test functionality of Log class.
 */

// Includes.
/*
#include "../Account.mqh"
#include "../Action.mqh"
#include "../Array.mqh"
//#include "../BasicTrade.mqh"
#include "../Buffer.mqh"
#include "../BufferStruct.mqh"
#include "../Chart.mqh"
#include "../Collection.mqh"
#include "../Condition.mqh"
#include "../Config.mqh"
#include "../Convert.mqh"
#include "../DateTime.mqh"
#include "../Dict.mqh"
#include "../DictBase.mqh"
#include "../DictObject.mqh"
//#include "../DictRef.mqh"
#include "../DictStruct.mqh"
#include "../Draw.mqh"
#include "../DrawIndicator.mqh"
#include "../EA.mqh"
#include "../File.mqh"
#include "../Indicator.mqh"
#include "../IndicatorData.mqh"
#include "../Inet.mqh"
#include "../JSON.mqh"
#include "../JsonIterator.mqh"
#include "../JsonNode.mqh"
#include "../JsonParam.mqh"
#include "../JsonSerializer.mqh"
#include "../Log.mqh"
#include "../MD5.mqh"
#include "../MQL4.mqh"
#include "../MQL5.mqh"
#include "../Mail.mqh"
#include "../Market.mqh"
#include "../Math.mqh"
#include "../Misc.mqh"
#include "../Msg.mqh"
#include "../Object.mqh"
#include "../Order.mqh"
#include "../Orders.mqh"
#include "../Profiler.mqh"
#include "../Queue.mqh"
#include "../Refs.mqh"
//#include "../Registry.mqh"
//#include "../RegistryBinary.mqh"
#include "../Report.mqh"
//#include "../SVG.mqh"
//#include "../Session.mqh"
//#include "../SetFile.mqh"
#include "../Stats.mqh"
//#include "../Strategies.mqh"
#include "../Strategy.mqh"
#include "../String.mqh"
#include "../SummaryReport.mqh"
#include "../SymbolInfo.mqh"
#include "../Task.mqh"
#include "../Terminal.mqh"
#include "../Test.mqh"
#include "../Tester.mqh"
//#include "../Tests.mqh"
#include "../Ticker.mqh"
#include "../Timer.mqh"
#include "../Trade.mqh"
#include "../Web.mqh"

#include "AccountTest.mq5"
#include "ActionTest.mq5"
#include "BufferStructTest.mq5"
#include "BufferTest.mq5"
#include "ChartTest.mq5"
#include "CollectionTest.mq5"
#include "ConditionTest.mq5"
#include "ConfigTest.mq5"
#include "ConvertTest.mq5"
#include "DictTest.mq5"
#include "DrawIndicatorTest.mq5"
#include "IndicatorTest.mq5"
#include "IndicatorsTest.mq5"
#include "LogTest.mq5"
#include "MailTest.mq5"
#include "MarketTest.mq5"
#include "OrderTest.mq5"
#include "ProfilerTest.mq5"
#include "RefsTest.mq5"
#include "StatsTest.mq5"
#include "StrategyTest.mq5"
#include "SummaryReportTest.mq5"
#include "SymbolInfoTest.mq5"
#include "TaskTest.mq5"
#include "TerminalTest.mq5"
#include "TickerTest.mq5"
#include "TimerTest.mq5"
#include "TradeTest.mq5"
#include "WebTest.mq5"
*/

#include "../Test.mqh"
#include "../Log.mqh"
#include "../DictStruct.mqh"

// Variables.
DictStruct<int, Ref<Log>> logs;

/**
 * Implements OnInit().
 */
int OnInit() {
  Ref<Log> log_trace = new Log(V_TRACE);
  Ref<Log> log_debug = new Log(V_DEBUG);
  Ref<Log> log_info = new Log(V_INFO);
  Ref<Log> log_warning = new Log(V_WARNING);
  Ref<Log> log_error = new Log(V_ERROR);

  logs.Push(log_trace);
  logs.Push(log_debug);
  logs.Push(log_info);
  logs.Push(log_warning);
  logs.Push(log_error);
  
  Ref<Log> sub_log_trace = new Log(V_TRACE);
  log_trace.Ptr().Link(sub_log_trace.Ptr());
  
  log_trace.Ptr().Trace("Trace", "Prefix", "Suffix");
  log_debug.Ptr().Debug("Debug", "Prefix", "Suffix");
  log_info.Ptr().Info("Info", "Prefix", "Suffix");
  log_warning.Ptr().Warning("Warning", "Prefix", "Suffix");
  log_error.Ptr().Error("Error", "Prefix", "Suffix");
  
  return (INIT_SUCCEEDED);
}

/**
 * Implements OnDeinit().
 */
void OnDeinit(const int reason) {}
