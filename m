Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C925317993
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Nov 2024 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732812424; cv=none; b=ab6BVwgjvEPvtznrDOFrIZcQWLSA1WHu8YkPuIQMQlam/ztPGP5Aj3ItjLp27TPkAaicyoSBCX0JBb2wq7iW070LNdXITJbotWSq2k3sXI3rmDLFPZpveMqgwhjmsP+3fn3XxW223Ird7a+UQKYlB9R0/08ep0QI1q7wr6/PmJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732812424; c=relaxed/simple;
	bh=qN1BVZeLJUZjyfFPMYiLwnibmO0IeO2MVIckXI60Xak=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=R/kZ0ncVqw9C0TyJJBWDyxNGIyjHhbRwQZxw7JB2B7Y71feJ/N1TOiy+SaH0einLnltibNrqP/InoHCRBX/nSLBrlHKAnETsvOAHB6kBQZ9f8hcDOJjnLp/wgUh1l2Nz/xL3XdbjvbQt2NfS4vBFSsQOGsPkinJYt47+mfafvsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a777d47a8eso16457295ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 28 Nov 2024 08:47:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732812422; x=1733417222;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB6QKltZBqgTuIMurRDLD1EU9kWoXkGKf5mAkXTzeZA=;
        b=BTxNa+c6JtokhSzxwvbjRFuUR513hxcLhwkq1yT4qAlTiPdL8qWbVyG9JKo69Ex+7N
         nagqzd1gOXvvGq60+mt8TbXZBrNNFXFhiYQeFQ2XrstB2kYJHd/SdBdwuUPsowDfr9yo
         xt2NwtcL8Og8ZveUzIDX1onTZUoOGibstdRUuBgEM6Ito09dH1uq5jN2zVtr+0Dyq6M1
         ZxGBJUrQ5DwsOSTRk8tC7IQWIuMNQEZgYxDerR80cdpj+tTJhSW8yDvlq58fTx14oB4K
         FLYpxyJGgXFlaGFmtp1FtQ/EeWBSPUD1Lt2N56l+axTJXKzfuW8Zv4RTJqiwB5lJYPmg
         oyjw==
X-Forwarded-Encrypted: i=1; AJvYcCUOagFX2FXkQmeUfg6ILEbAhakSO/wJU81FxMim3GJjoFD8nQQDIEv7ahCCc4uDGxo7v1wrTsRaXpI1VDFWqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxB2FizaEMEo88wgF7ETOXIWp2O4A3pYsdeO1+DAZLCSN8Hu87J
	L8CdAN6TKE/DaOJ7fbREgF1JWfLN72oQ2gyxB+PVe3pirfKdZblYDx494R13KQzVagvAxVEPL2g
	24/H39oNQVHMhoF2nbIWY6VUG/wusTTvU7AwNG57EViJNK0/a/V4CQF8=
X-Google-Smtp-Source: AGHT+IGy73L+vWVZwSdwyqjH0wowFE8DqdHmgCJRRlhDtScRZ/8AHk/G68GnqvDB47rZRjSRuLeAnzjjBbs5SrYs+07ze2mvwjsD
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178c:b0:3a7:8149:6aa with SMTP id
 e9e14a558f8ab-3a7c55fc480mr76935615ab.24.1732812422060; Thu, 28 Nov 2024
 08:47:02 -0800 (PST)
Date: Thu, 28 Nov 2024 08:47:02 -0800
In-Reply-To: <67483ca4.050a0220.253251.007d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67489e86.050a0220.253251.008a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_get_scanned_nodes
From: syzbot <syzbot+64e6509c7f777aec3a24@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 50eecc37ec7c9caab87c938b912bb5c686316ea5
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Nov 27 05:29:52 2024 +0000

    bcachefs: struct bkey_validate_context

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a64f78580000
start commit:   f486c8aa16b8 Add linux-next specific files for 20241128
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12a64f78580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14a64f78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e348a4873516af92
dashboard link: https://syzkaller.appspot.com/bug?extid=64e6509c7f777aec3a24
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1389ef5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164a8f78580000

Reported-by: syzbot+64e6509c7f777aec3a24@syzkaller.appspotmail.com
Fixes: 50eecc37ec7c ("bcachefs: struct bkey_validate_context")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
