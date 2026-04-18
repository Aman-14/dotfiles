import { List } from "@raycast/api";
import { useState, useMemo } from "react";
import { Fzf } from "fzf";

const names = [
  "John Doe",
  "Jane Smith",
  "Michael Johnson",
  "Emily Brown",
  "David Wilson",
  "Sarah Davis",
  "Robert Taylor",
  "Jennifer Anderson",
  "William Thomas",
  "Lisa Martinez",
];

export default function SearchRepos() {
  const [searchText, setSearchText] = useState("");

  const fzf = useMemo(() => new Fzf(names), []);

  const filteredNames = useMemo(() => {
    if (searchText === "") return names;
    return fzf.find(searchText).map((entry) => entry.item);
  }, [searchText, fzf]);

  return (
    <List onSearchTextChange={setSearchText} searchBarPlaceholder="Search names..." throttle>
      {filteredNames.map((name) => (
        <List.Item key={name} title={name} />
      ))}
    </List>
  );
}
