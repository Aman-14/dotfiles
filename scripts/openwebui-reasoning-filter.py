from pydantic import BaseModel


class Filter:
    _thinking_started = None

    class Valves(BaseModel):
        pass

    def __init__(self):
        self.valves = self.Valves()

    def stream(self, event: dict) -> dict:
        # This is where you modify streamed chunks of model output.
        print(f"stream event: {event}")
        delta = event["choices"][0]["delta"]
        reasoning = delta.get("reasoning")

        if self._thinking_started is None and reasoning is not None:
            # Start thinking - add opening tag and reasoning
            self._thinking_started = True
            delta["content"] = f"<think>{reasoning}"
            return event
        elif self._thinking_started and reasoning is None:
            # End thinking - add closing tag
            self._thinking_started = None
            delta["content"] = "</think>" + (delta.get("content", "") or "")
            return event
        elif self._thinking_started and reasoning is not None:
            # Continue thinking - add reasoning to content
            delta["content"] = reasoning + (delta.get("content", "") or "")
            return event

        return event
