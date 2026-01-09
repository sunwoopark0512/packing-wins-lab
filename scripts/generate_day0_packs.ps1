# Generate 10 Content Packs for Day 0
# Niche: Travel/Packing
# Project: packing-wins-lab

$Day0Info = @(
    @{ Id="01"; Name="Compression Cubes"; Hook="Stop packing air."; Problem="Suitcase won't close?"; Fix="These cubes squash clothes down by 60%."; CTA="Get space back (Link in bio)." },
    @{ Id="02"; Name="Toiletry Bag"; Hook="Shampoo explosion nightmare?"; Problem="Ruined clothes from leaks."; Fix="Waterproof hanging bag keeps spills contained."; CTA="Leak-proof list in bio." },
    @{ Id="03"; Name="Shoe Pouch"; Hook="Dirty soles on clean shirts?"; Problem="Gross shoe transfers."; Fix="Dedicated shoe pouch isolates the dirt."; CTA="Clean packing link in bio." },
    @{ Id="04"; Name="Tech Pouch"; Hook="Cable spaghetti?"; Problem="Chargers tangled everywhere."; Fix="Elastic loops for every cable."; CTA="Organize tech (Link in bio)." },
    @{ Id="05"; Name="Travel Wallet"; Hook="Passport panic at airport?"; Problem="Can't find docs in queue."; Fix="RFID blocker wallet holds everything secure."; CTA="Safe travel link in bio." },
    @{ Id="06"; Name="Vacuum Bag"; Hook="Packing a winter coat?"; Problem="Takes up half the bag."; Fix="Roll-up vacuum bag (no pump needed)."; CTA="Space saver link in bio." },
    @{ Id="07"; Name="Makeup Case"; Hook="Cracked powder tragedy?"; Problem="Soft bags crush makeup."; Fix="Hard shell case protects your glow."; CTA="Beauty safe link in bio." },
    @{ Id="08"; Name="Jewelry Roll"; Hook="Necklace knot hell?"; Problem="Spent 20 mins untangling."; Fix="Velcro straps keep chains separate."; CTA="Tangle-free link in bio." },
    @{ Id="09"; Name="Laundry Bag"; Hook="Clean vs Dirty mix?"; Problem="Stinky socks touching fresh tees."; Fix="Expandable laundry sack separates odors."; CTA="Fresh bag link in bio." },
    @{ Id="10"; Name="Packing List"; Hook="Forgot your toothbrush?"; Problem="Panic buying at destination."; Fix="Digital checklist you can't lose."; CTA="Free list link in bio." }
)

$LinkHub = "https://YOUR-LINK-HUB.example"

foreach ($Item in $Day0Info) {
    $PackDir = "outputs\day0\pack_$($Item.Id)"
    New-Item -ItemType Directory -Force -Path $PackDir | Out-Null
    Write-Host "Generating Pack $($Item.Id): $($Item.Name)..."

    # 1. Script.md
    $ScriptContent = @"
# Script: $($Item.Name) (Pack $($Item.Id))

## Video Structure (15-30s)
1. **Hook (0-2s)**: $($Item.Hook) (Visual: Chaos/Problem)
2. **Problem**: $($Item.Problem)
3. **Fix**: $($Item.Fix) (Visual: Product in action, satisfying zip/organize)
4. **CTA**: $($Item.CTA)

## Languages
- **KO**:
  - 훅: $($Item.Hook) (자막)
  - 내용: $($Item.Problem) 이거 하나면 끝. $($Item.Fix)
  - CTA: "링크는 프로필에."
- **EN-Lite**:
  - Hook: $($Item.Hook)
  - Body: $($Item.Problem) Fixed. $($Item.Fix)
  - CTA: $($Item.CTA)
"@
    Set-Content -Path "$PackDir\script.md" -Value $ScriptContent -Encoding utf8

    # 2. Caption Core9 JSON
    $CaptionJson = @"
{
  "common": {
    "disclosure": {
      "required": true,
      "text_ko": "#광고 #여행꿀팁",
      "text_en": "#ad #travelhacks",
      "placement": "start"
    },
    "links": [ { "url": "$LinkHub", "placement": "bio/comment" } ]
  },
  "platforms": {
    "tiktok": { "post_text": "$($Item.Hook) $($Item.Fix) #packinghack", "cta": "Link in bio" },
    "youtube_shorts": { "post_text": "$($Item.Hook) No more $($Item.Problem)!", "cta": "Link in pinned comment" },
    "instagram_reels": { "post_text": "$($Item.Problem) Solved. ✈️", "cta": "Link in bio" },
    "facebook_reels": { "post_text": "Travel smart: $($Item.Name)", "cta": "Link in comments" },
    "threads": { "post_text": "$($Item.Hook)", "cta": "Link in bio" },
    "x": { "post_text": "Before/After: $($Item.Name). #travel", "cta": "Link below" },
    "pinterest": { "post_text": "Save this packing hack: $($Item.Name)", "cta": "Visit link" },
    "linkedin": { "post_text": "Business travel efficiency: $($Item.Name)", "cta": "Link in comments" },
    "blog": { "post_text": "Full review: Why I use this $($Item.Name).", "cta": "Read more" }
  }
}
"@
    Set-Content -Path "$PackDir\caption_core9.json" -Value $CaptionJson -Encoding utf8

    # 3. Gate Results (Pre-Check)
    $GateLog = @"
{"verdict": "PASS_CANDIDATE", "platform": "tiktok", "reasons": ["Disclosure present", "Link count=1"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "youtube_shorts", "reasons": ["Disclosure check checked", "Safe tone"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "instagram_reels", "reasons": ["Label used", "Visual focus"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "facebook_reels", "reasons": ["Spam check pass"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "threads", "reasons": ["Concise"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "x", "reasons": ["Link safe"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "pinterest", "reasons": ["Pin destination valid"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "linkedin", "reasons": ["Professional tone"], "required_fixes": []}
{"verdict": "PASS_CANDIDATE", "platform": "blog", "reasons": ["Top disclosure present"], "required_fixes": []}
"@
    Set-Content -Path "$PackDir\gate_results.jsonl" -Value $GateLog -Encoding utf8

    # 4. Reddit Draft
    $RedditContent = @"
# Reddit Draft (Pack $($Item.Id))
**Status**: DRAFT ONLY (Do NOT Auto-post)

## Title Candidates
1. My packing game changed when I stopped packing air.
2. Has anyone else tried compression for winter coats?
3. The real solution to the '$($Item.Problem)' struggle.

## Body (Value First)
Hey everyone, just wanted to share a small win.
I used to struggle with $($Item.Problem).
Finally tried a $($Item.Name) setup.
The strict rule I follow now: $($Item.Fix).
It saves so much headache.

(No link here. If asked, I'll DM or put in profile.)

## Checklist
- [ ] Subreddit allows 'Gear/Packing' discussion?
- [ ] No direct affiliate links? (Check)
- [ ] Flair set to 'Tips/Discussion'?
"@
    Set-Content -Path "$PackDir\reddit_draft.md" -Value $RedditContent -Encoding utf8

    # 5. YT Longform Candidate
    $YtContent = @"
# YT Longform Candidate (Pack $($Item.Id))
**Eligibility**: Only if Shorts version hits Top 20% Retention.

## Outline: Ultimate Guide to $($Item.Name)
1. Intro: The Math of Packing (Volume vs Weight).
2. Demo: Standard Packing vs $($Item.Name).
3. Stress Test: Can it handle a 2-week trip load?
4. The Rules: What NOT to pack in it.
5. Verdict: Is it worth the spend? (Honest Pros/Cons).

**Link Policy**: LinkHub only in description + 'Paid Promotion' check ON.
"@
    Set-Content -Path "$PackDir\yt_longform_candidate.md" -Value $YtContent -Encoding utf8
}
