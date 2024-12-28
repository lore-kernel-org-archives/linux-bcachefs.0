Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B94A2AE84
	for <linux-bcachefs@vger.kernel.org>; Sat, 28 Dec 2024 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735405744; cv=none; b=YzmcMhU3MQPfRjzWRDpyo0Pkm1/4vBNcgvnU0nUqEqLLq20iZXpi3NJNK1oDRAktoZv44E16gpiLLy8ATZmsWpQQED9YLOmN5pPEeQAyYrKMXG+EJa7HE81ahVSCAyQS3HoXCpB2uY6EFu7RR1Kc/2NxCarS9PPTrQO0aBmOEQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735405744; c=relaxed/simple;
	bh=QXv+LMEkSCdie+M1tUbv5blliD2bMKd4qfBZAIT78nY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=l8c+rnRBRREcGnHR1BI8259B8bPTN+B32QDwWIrO0Y3YwrgC13Sx8+VZi7FIVv876wBvhyDAevToAJcZLvc9vhyn9Yvt4d8CcBr/ppf625x0JlPosJCSTPDoOFgY52hzEqXt+DqJi0LQxm9G7Lh0aXEpnjVQ4t5Rg8oJIeIUx4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a78c40fa96so61951555ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 28 Dec 2024 09:09:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735405742; x=1736010542;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZcTt5wNODzV4ymWgimvaflJ/wBP8nYeSyTJTtEV9sY=;
        b=kiU8lvqM4aOpTfawln4OS2sGaQbkEjmtxde6G/LrXgvX6LkYSZTfSfSp6g7jl/HFP6
         KQ9R5pRgcJ0EpXvK8k0SpvwExScJOMT/vgqyKXr56TV99GSPAonzALate7xVTMwMBKOm
         QkiezOBxEasqF2BdP1+Jgjfl5tUPdBYO41pJqKXe20gjAoTDNw8Qluewt5vTJgK6+QXy
         XWrU0Hh1BBnaG2WaRERnAb3wmdEX/+t8pqzE0IubHsPg3I4VO4p37S8wGoOJr0lJoFpo
         vfbuiqvKU83+H47dd8w7r8IBkN4jE87S+MiUtaFuN9O4j2FXfQUbX6+rGIzDq7m6zayO
         WMlg==
X-Forwarded-Encrypted: i=1; AJvYcCUc/HTU3fivsgzmTuQ9OzMSDrQdBJklQIDuTuzDOSChSUIwfj/I2IkhhQ7rufmLxuBp23n6tM+Z0uVnnQMEcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeOQs4WxnPVCCAdPnk2V9UWfaLuCXZDNmp/dTkjhy2xRzBSVcv
	wvGICUT29Hzwou0qGoXpEAjF3BSyNY16T3DAa/zcQXljQj1nNHmCRTxGhWIpy2PaRGym9UL+812
	tm0EBZ5t+zYbYclqIbs0NBjXFx9nNwO3AcSIUzAP+SBQcmjPT/gFJtcY=
X-Google-Smtp-Source: AGHT+IHa8AMsCduRf9JDHOTy8Djorvmuz34ixSapIcc8DCKkGF4sJWU/UHMwHD8diZ9eSKdenpyXFE8Q1z6xiQeMC6SR7YmWqxFx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aaa:b0:3a7:e103:3c43 with SMTP id
 e9e14a558f8ab-3c2d514fb31mr268602885ab.19.1735405741808; Sat, 28 Dec 2024
 09:09:01 -0800 (PST)
Date: Sat, 28 Dec 2024 09:09:01 -0800
In-Reply-To: <000000000000545c120618dd6c63@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677030ad.050a0220.226966.00b0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_readahead
From: syzbot <syzbot+a6060114362257e9798a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 1d16c605cc55ef26f0c65b362665a6c99080ccbc
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Nov 9 19:22:46 2023 +0000

    bcachefs: Disk space accounting rewrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123350b0580000
start commit:   eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=113350b0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=163350b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=a6060114362257e9798a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b47730580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d75f44580000

Reported-by: syzbot+a6060114362257e9798a@syzkaller.appspotmail.com
Fixes: 1d16c605cc55 ("bcachefs: Disk space accounting rewrite")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
