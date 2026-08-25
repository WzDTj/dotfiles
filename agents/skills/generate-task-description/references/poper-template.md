# Poper Task Description Template

Use the Jira issue's existing headings when they differ. For the standard template, preserve this order:

```markdown
**Release Note (If needed)**

None

#### **1. 仕様と背景**

#### **2. 実装のLogic**

<plain-language operating principle and resulting behavior>

#### **3. テスト流れ**

<observable verification steps>

#### **4. 影響範囲**

<affected product surfaces or workflows, or None>

#### **5. 通知影響ある？ (ベルマーク, Line, Push, Email) ※ 「Notification」更新する必要があります**

<notification impact or None>

#### **6. 変更の共通のファイルがある？**

<shared-file impact or None>

#### **7. Engineer自分テストの所**

已按「テスト流れ」测试

#### **8. (confluence) 権限一覧変更の所**

<permission-document impact or None>

#### **9. (confluence) DB変更の所**

<database-document impact or None>

#### **10. 仕様変更履歴**

<specification-history impact or None>
```

Use `None` only when the corresponding topic is not involved. Do not replace supported impact with `None` merely to shorten the description.
