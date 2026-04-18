import { Action, ActionPanel, Cache, List } from "@raycast/api";
import { useFetch } from "@raycast/utils";
import { Fzf } from "fzf";
import { useEffect, useState } from "react";

// Define the type for our models
type Model = {
  id: string;
  name: string;
  description: string;
};

// Default models as fallback
const defaultModels: Model[] = [
  {
    id: "gpt-4-turbo-preview",
    name: "GPT-4 Turbo",
    description: "Most capable model, best at complex tasks",
  },
  {
    id: "gpt-4",
    name: "GPT-4",
    description: "More capable than GPT-3.5, better at complex tasks",
  },
  {
    id: "gpt-3.5-turbo",
    name: "GPT-3.5 Turbo",
    description: "Fast and efficient for most tasks",
  },
];

export default function Command() {
  const [searchText, setSearchText] = useState("");
  const [selectedModel, setSelectedModel] = useState<Model | null>(null);
  const cache = new Cache();
  const CACHE_KEY = "ai_models";
  const CACHE_DURATION = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

  // Check if we need to fetch new data
  const shouldFetch = () => {
    const cached = cache.get(CACHE_KEY);
    if (!cached) return true;

    const { timestamp } = JSON.parse(cached);
    return Date.now() - timestamp >= CACHE_DURATION;
  };

  const { data: fetchedModels } = useFetch<{ data: Model[] }>("https://openrouter.ai/api/v1/models", {
    execute: shouldFetch(),
  });

  useEffect(() => {
    if (fetchedModels?.data) {
      cache.set(
        CACHE_KEY,
        JSON.stringify({
          models: fetchedModels.data,
          timestamp: Date.now(),
        }),
      );
    }
  }, [fetchedModels]);

  const getModels = (): Model[] => {
    const cached = cache.get(CACHE_KEY);
    if (cached) {
      const { models: cachedModels } = JSON.parse(cached);
      return cachedModels;
    }
    return fetchedModels?.data || defaultModels;
  };

  const models = getModels();

  const isModelSearch = searchText.startsWith("@");
  const modelSearchText = isModelSearch ? searchText.slice(1) : "";

  // Create FZF instance for model search
  const fzf = new Fzf(models, {
    selector: (item) => item.name + " " + item.description,
  });

  // Get fuzzy search results
  const searchResults = isModelSearch ? fzf.find(modelSearchText) : [];

  // Default model when not explicitly selected
  const defaultModelId = "google/gemini-2.0-flash-001";

  return (
    <List
      searchText={searchText}
      onSearchTextChange={setSearchText}
      searchBarPlaceholder={isModelSearch ? "Search AI models..." : "Enter your query..."}
    >
      {isModelSearch &&
        searchResults.map(({ item: model }) => (
          <List.Item
            key={model.id}
            title={model.name}
            subtitle={model.description}
            actions={
              <ActionPanel>
                <Action
                  title="Select Model"
                  onAction={() => {
                    setSelectedModel(model);
                    setSearchText("");
                  }}
                />
              </ActionPanel>
            }
          />
        ))}
      {!isModelSearch && (
        <List.Item
          title="Send Query"
          subtitle={searchText || "Type your query above (or '@' to choose a different model)"}
          actions={
            <ActionPanel>
              <Action.OpenInBrowser
                title="Open in ChatGPT"
                url={`http://docker.home.server:3009?model=${encodeURIComponent(
                  selectedModel?.id || defaultModelId,
                )}&q=${encodeURIComponent(searchText)}`}
              />
            </ActionPanel>
          }
        />
      )}
    </List>
  );
}
