Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A39801
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 May 2024 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714869306; cv=none; b=fp4rlGazpPzh5HknXUYKVzNN+SJYxVYcQveYghDsci/udWzOwCTnjaJoqdAVL4YsflXdgIviSUavV6uXwPlB+syQd8VdHyR0UsfrVPYfIASDWLtVJReaEjkaqAxuZaSVYrPSZ44eoqQCxmhxQ+DHAEt8x/2Uj5P/ZhFYB6o1OeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714869306; c=relaxed/simple;
	bh=3lWAJAfUZvClkbre3n9Mn5LFR4Th6NocSJxukhF+bcc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=aVEzkGPM7Rrue732ZXxCzPsm9bsozO4ui6w3C9xnKO0bAb5D9KxdfJhWNLHFoiKIr5CLCyRYU09q2IB2Id8tFAB37rFs290R6hBib2FbdK7v7ck/CVDFPdF1NWBtcY1y/omGhjn5PtEaC/YCE/7nT+Gepxa2BVLP/6UYXPpTKHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7d9d0936d6aso114849839f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 04 May 2024 17:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714869304; x=1715474104;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GQCgYFbXCI7Q2niaNhE+aI9odULkuIJr2iIWjifovcE=;
        b=KYZNDgISpzwV0ANst0n7LXgFyoTkK3YZ8p3ubbydgyKjtGY6/G+ecvIqyxEqXvvcon
         LQnfvj499CY8LrIn2I+xj5j2GPpkBEIfpexuICT7tsS5hTgbFQ7QwgjyoCQ3e95JcFgU
         27eLoB0SM18oJbpxUNP/2S0KWW0Dk8PNWWa4DKyasdnCr4gbW54xqER3PsE/I8DRAd1y
         /cXwbL3vfaNZLw5tKTW2UX3zMjH4EvKzreyrP1UL7hA+4CZQJHfFMs+sU6a2yfBQ6KK/
         6mvUGUpUf/8na1ASCtvRprqMMRMVa57IE5JMr0k0ss//Jc3krvUep82wjj/VJnxR6ety
         WH6A==
X-Forwarded-Encrypted: i=1; AJvYcCWCNHzQOkT1vaji5joQZ8ocksLLSutrSmloQZOvOCZl1quQmC5nCTUXe1z4Lz0R4GjsmUbfA1J/dsV/dpUyLjDZqGOGhkXv1EWCCyJDmzg=
X-Gm-Message-State: AOJu0YxjsbVGaAxDrOfD9W7/HT39n3t4GqwUIzHTt8bWFwbSMlb4agtX
	3jaF/5m0dBgO0zLKBE6WbPahlCyYqo6uLq13DWW154z5/1DdY5y9t5BahP4NCRXj4mtokQkwdME
	CzZtRMKwZL5Dtdo3kv+pFpUi2rNvzOqdRrDk3lVbUrUe9dJ3xL4qHp4U=
X-Google-Smtp-Source: AGHT+IGh+xKJ+7qu7/Kpc0kJl8tdSzMHzURQUBwlqmWGnbvGT87sd1no6wsbnRY27qj6vprI8ShhDr4RJxAvf8ptQ+TdM8P9qgTW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:614b:b0:487:cd4:4bda with SMTP id
 ez11-20020a056638614b00b004870cd44bdamr247216jab.4.1714869304673; Sat, 04 May
 2024 17:35:04 -0700 (PDT)
Date: Sat, 04 May 2024 17:35:04 -0700
In-Reply-To: <0000000000003392c606179ddd1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bdedb60617aa1f12@google.com>
Subject: Re: [syzbot] [bcachefs] KASAN: use-after-free Read in scatterwalk_copychunks
From: syzbot <syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com>
To: bfoster@redhat.com, davem@davemloft.net, herbert@gondor.apana.org.au, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit dc6f2eb000d76ac8f93f4d59a8012ddfccca927a
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16629450980000
start commit:   9221b2819b8a Add linux-next specific files for 20240503
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15629450980000
console output: https://syzkaller.appspot.com/x/log.txt?x=11629450980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ab537f51a6a0d98
dashboard link: https://syzkaller.appspot.com/bug?extid=8c4acf719c3fc41e8439
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111abc97180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10059004980000

Reported-by: syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com
Fixes: dc6f2eb000d7 ("bcachefs: make btree read errors silent during scan")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
