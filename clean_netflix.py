import pandas as pd


df = pd.read_csv("netflix_data.csv")

##Remove duplicates
df.drop_duplicates(inplace=True)

##Strip whitespace from strings
df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)


## Fill or replace missing spots with 'Unknown'
df['director'].fillna('Unknown', inplace=True)
df['cast'].fillna('Unknown', inplace=True)
df['country'].fillna('Unknown', inplace=True)


## Drop rows where critical fields are missing
df.dropna(subset=['show_id', 'type', 'title'], inplace=True)

## Ensure correct types
df['release_year'] = pd.to_numeric(df['release_year'], errors='coerce')
df['release_year'] = df['release_year'].fillna(0).astype(int)

## Standardize 'duration' field
df['duration'] = df['duration'].str.extract(r'(\d+)').fillna(0).astype(int)



df.to_csv("cleaned_netflix_data.csv", index=False)
print("Cleaned data saved to cleaned_netflix_data.csv")
