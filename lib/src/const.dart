const String kCommonKeyValuesPrompt = '''
I have translations for specific languages structured as the example.
Please complete only the missing translations for each provided key and language without introducing any new keys or languages.

Instructions:
- Translate and fill missing values based on the keys and languages given.
- Do not add any new languages or keys.
- If unsure of a translation, leave the value as an empty string "".

- please dont return more than 1 json in the same time
''';
// - Return the completed JSON structure directly as a plain text string, not JSON-encoded.
const String kCommonKeyValuesExample = '''
Example:
Input:  
- {"key":"food", "en":""}
- {"key":"key1","en":"hello","ar":""}  

Output:  
- {"key":"food", "en":"Food"}
- {"key":"key1","en":"hello","ar":"مرحبا"}  
''';