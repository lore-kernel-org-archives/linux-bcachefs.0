Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944232D592E
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Dec 2025 01:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767145325; cv=none; b=R7Zup2ZvVyCo3IfWbC6ooouYO9WHizIsD1Dmm4zogW8BbKdZoHhBZnzSrlG4xOCZ9I7WyaGdFszPa7LY8Ecdn/hmip3sRiD4MrI0KVZiZFILOSgeliUByTab4kGYAeFg0t+KV5I4rvj37u7eYpCDfkSWpiikjh3trzZ3MUWtQP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767145325; c=relaxed/simple;
	bh=Zxm+JxbQDcWg11BOhyw7dobOfjO2hvH3NDQOCPh97Jw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Yi30QabhszDNGAcTHQAI2nWkQB1Y5FOcFfaf75zkngmwPqX9n0z2DUH1bPn35sDtsy7LAlg0F+VShPuBwB6tfr3s8Tj5Z2JjDG/ERUeUVww0v4BsvWrmwQAzWLja+la2WxKGrB+IxTw1adYr5m77kalns3tCIbEIQJ40ekGmkF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65ec1bb9db9so12975378eaf.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 30 Dec 2025 17:42:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767145322; x=1767750122;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTZZjS79VHrfpj0W1pWmRNTRak1AXpPtMEXkehl7HRk=;
        b=ORWn9XwMnK99EUsd5uqV+LlfeQI6zj/ONKxiXgF+8rMWJSMEHRwuQGBCKGPbgbERpi
         cbW532OC6JndyVfQRPOJLv/nQtCcR7h/T3kMebYz8XSTUI4raAwhcWeF+aqLfuMovMBe
         L57g5rB4pa+WHgJ96Nrkc8yecxqThZANog1ny/Odp6GZuIa5V8n+19whxAFTm6Tjjp29
         unKhWtOfYHUqCrW/2fwR4htw1xDidz0C/f2e6pY2WR7qwgSgazjZs3kHydBEUwoXvd//
         yJhpOD58YI1FqPdH5zM/Qc6pjpQvE44fWBugQbb64BMf5r53YFU2LznHB0Q1nwJ+04rd
         Mskg==
X-Forwarded-Encrypted: i=1; AJvYcCWfflOamABJ4VhZzx4B9hVKacdLdhmfxA8mCREfCFclukhjjArwXGKnM/SwLFgpl4agVcKrMS/uYBnuLxbreQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXKF3wCbmCY0TkjJE434DQRaLAzWJZIMV6gmjg8ZPQTTyFsdX5
	Hkrkqo/g/OVvlJBNVXLIJxFyCt/owuFUYgjy8txHXlPdzSbW3lE7W7OtRIGXWuIXBFb+jxvXlYg
	vWZLpX7vfkG7DJcb/rsKhkAhd53Ul42q5XG9aEhkKAxYlmHfDwK4HzzGnuUA=
X-Google-Smtp-Source: AGHT+IHxNzByy/IIqB+GfG++jCTnMxPHAU+BIqEALwrSkaIPtHK7tKgpL7oIzY6zR37aqpu0Jo5qfft1DeP4tsACTpcUsq5RaQ94
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2305:b0:65c:fb01:71af with SMTP id
 006d021491bc7-65ea0345582mr11615339eaf.5.1767145322587; Tue, 30 Dec 2025
 17:42:02 -0800 (PST)
Date: Tue, 30 Dec 2025 17:42:02 -0800
In-Reply-To: <67a4eae3.050a0220.65602.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69547f6a.050a0220.a1b6.0308.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in list_lru_del
From: syzbot <syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, gfs2@lists.linux.dev, 
	hughd@google.com, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mmpgouride@gmail.com, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 3a04334d6282d08fbdd6201e374db17d31927ba3
Author: Alan Huang <mmpgouride@gmail.com>
Date:   Fri Mar 7 16:58:27 2025 +0000

    bcachefs: Fix b->written overflow

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117f329a580000
start commit:   03d38806a902 Merge tag 'thermal-6.14-rc5' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de9cc84d5960254
dashboard link: https://syzkaller.appspot.com/bug?extid=6663075ddb9be85fa6e5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104d2864580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix b->written overflow

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
