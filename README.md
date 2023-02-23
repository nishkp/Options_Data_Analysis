# Quant Options Order Log Data Analysis

## Prompt:
Attached is a log file called test.csv generated from a simulated equity options strategy run on 10-12-2021. There are two types of log messages, each coming from one of two components of the simulated system: (1) Order signals from the Strategy Engine (SE); and (2) corresponding order events from Order Manager (OM).

#### The SE observes the market and generates order instructions where it sees opportunities. Any time the SE generates a set of instructions, it logs:
* Security mapping OptionId, unique to each option instrument.
* UnderlyingSymbol, Expiration, Strike and CallPut flag describing the given instrument.
* Side, Size, Price and destination Exchange for order.
* Display size of the opposite side of the quote for the given exchange at the time the SE sent the instructions (MarketSize).
#### The OM receives order instructions from the SE, and either: (1) Converts these instructions to ‘NEW’ orders, forwarding them to the market; or (2) Rejects the SE’s instructions. ‘NEW’ order messages will be followed by a second ‘FILL’ or ‘CANCEL’ message from the OM based on whether or not a given order filled in the market. For each order event, the OM will log:
* OptionId matching that of SE order instructions for the same instrument.
* Sequence number, unique to each order (OrderId); can be used to correlate ‘FILL’ or ‘CANCEL’ with initial ‘NEW’ orders.
* OrderEventType (e.g. NEW, REJECT, FILL or CANCEL).

All orders can be assumed to be immediate-or-cancel and there will be no partial fills.
Report on any patterns you identify that may be used to: (1) Increase fill rate; and/or (2) reduce latency. Log parsing, analysis, and reporting may be executed in/on any language/platform. All work submitted will be considered; e.g. how you arrive at the results is as important as the results themselves. 
