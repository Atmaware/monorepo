import { App, Plugin, PluginSettingTab, Setting, Modal, Notice } from 'obsidian';
import { exec } from 'child_process';
import { promisify } from 'util';
import * as path from 'path';

const execAsync = promisify(exec);

interface ChatGPTConverterSettings {
    outputFolder: string;
}

const DEFAULT_SETTINGS: ChatGPTConverterSettings = {
    outputFolder: 'chatgpt'
}

export class URLInputModal extends Modal {
    urls: string;
    onSubmit: (urls: string) => void;

    constructor(app: App, onSubmit: (urls: string) => void) {
        super(app);
        this.onSubmit = onSubmit;
    }

    onOpen() {
        const { contentEl } = this;

        // Title
        contentEl.createEl('h2', { text: 'Enter ChatGPT URLs' });

        // Instructions
        const instructions = contentEl.createEl('p', {
            cls: 'chatgpt-converter-instructions',
            text: 'Enter the URLs of your shared ChatGPT conversations (one per line). You can find these by clicking "Share" on any ChatGPT conversation.'
        });

        // URL Input
        const urlInput = contentEl.createEl('textarea', {
            attr: {
                placeholder: 'Paste your ChatGPT conversation URLs here...',
                rows: '10',
                style: 'width: 100%; font-family: monospace; padding: 8px; margin: 10px 0; border-radius: 4px; border: 1px solid var(--background-modifier-border);'
            }
        });

        // Button Container
        const buttonContainer = contentEl.createEl('div', {
            cls: 'chatgpt-converter-buttons'
        });

        // Convert Button
        const submitButton = buttonContainer.createEl('button', {
            text: 'Convert',
            cls: 'mod-cta'
        });

        // Cancel Button
        const cancelButton = buttonContainer.createEl('button', {
            text: 'Cancel',
            cls: 'chatgpt-converter-cancel'
        });

        // Event Listeners
        submitButton.addEventListener('click', () => {
            this.urls = urlInput.value;
            this.close();
            this.onSubmit(this.urls);
        });

        cancelButton.addEventListener('click', () => {
            this.close();
        });

        // Add styles
        contentEl.createEl('style', {
            text: `
                .chatgpt-converter-instructions {
                    margin-bottom: 15px;
                    color: var(--text-muted);
                }
                .chatgpt-converter-example {
                    margin-bottom: 15px;
                    padding: 8px;
                    background: var(--background-secondary);
                    border-radius: 4px;
                }
                .chatgpt-converter-example code {
                    word-break: break-all;
                }
                .chatgpt-converter-buttons {
                    display: flex;
                    justify-content: flex-end;
                    gap: 10px;
                    margin-top: 15px;
                }
                .chatgpt-converter-cancel {
                    color: var(--text-muted);
                }
            `
        });

        // Focus the textarea
        urlInput.focus();
    }

    onClose() {
        const { contentEl } = this;
        contentEl.empty();
    }
}

export class ChatGPTConverterSettingTab extends PluginSettingTab {
    plugin: ChatGPTConverterPlugin;

    constructor(app: App, plugin: ChatGPTConverterPlugin) {
        super(app, plugin);
        this.plugin = plugin;
    }

    display(): void {
        const { containerEl } = this;
        containerEl.empty();

        new Setting(containerEl)
            .setName('Output folder')
            .setDesc('Folder where converted conversations will be saved')
            .addText(text => text
                .setPlaceholder('chatgpt')
                .setValue(this.plugin.settings.outputFolder)
                .onChange(async (value) => {
                    this.plugin.settings.outputFolder = value;
                    await this.plugin.saveSettings();
                }));
    }
}

export default class ChatGPTConverterPlugin extends Plugin {
    settings: ChatGPTConverterSettings;

    async onload() {
        await this.loadSettings();

        this.addCommand({
            id: 'convert-chatgpt-conversations',
            name: 'Convert ChatGPT Conversations',
            callback: () => {
                new URLInputModal(this.app, async (urls) => {
                    if (!urls.trim()) {
                        new Notice('Please enter at least one URL');
                        return;
                    }

                    const urlList = urls.split('\n').filter(url => url.trim());
                    await this.convertConversations(urlList);
                }).open();
            }
        });

        this.addSettingTab(new ChatGPTConverterSettingTab(this.app, this));
    }

    async loadSettings() {
        this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
    }

    async saveSettings() {
        await this.saveData(this.settings);
    }

    async convertConversations(urls: string[]) {
        try {
            const adapter = this.app.vault.adapter as any;
            const vaultPath = adapter.getBasePath?.() || adapter.basePath;
            const outputPath = path.join(vaultPath, this.settings.outputFolder);
            const pluginRoot = path.join(vaultPath, this.app.vault.configDir, 'plugins', 'conversation-importer');
            const converterPath = path.join(pluginRoot, 'converters', 'chatgpt.py');
            const pyvenvPath = path.join(pluginRoot, 'converters', 'venv', 'bin', 'activate');
            
            // Create output directory if it doesn't exist
            await this.app.vault.adapter.mkdir(this.settings.outputFolder);

            const urlsArg = urls.join(' ');
            const command = `source "${pyvenvPath}" && python "${converterPath}" ${urlsArg} --output "${outputPath}" --md`;

            new Notice('Converting conversations...');
            
            const { stdout, stderr } = await execAsync(command);
            
            if (stderr) {
                console.error('Conversion error:', stderr);
                new Notice('Error converting conversations. Check console for details.');
                return;
            }

            new Notice('Conversations converted successfully!');
            
        } catch (error) {
            console.error('Error:', error);
            new Notice('Error converting conversations. Check console for details.');
        }
    }
}
