Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12B2837B
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734800704; cv=none; b=Xx7WZk/m+kFpzOuM+o9I6EPqMM9jeufWzCStbTwDxMYiIOxqGi0HbdEfW+uWi9JtVqpHDqW0d67lT1KBsVV+ulalZDTgERRNMJ7PL3XDZ7FhBwzQE32ao3vNxwNuO1y9QZGDQ3xw3vvi1gi2U8RRSpuHImmnJfZ9WKjSaiD70Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734800704; c=relaxed/simple;
	bh=OalUfHvJXQ98F/2TZEczyhIo4oroIs4uG0r0CZ+YbsQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=t/rAuyG2JBCH/3F4i8w+xPuuxJ74Hgxud8qIFe1fcemFVrAvfyOOz5PvGnajgwxKLBD7DnYG1hWtv5ZcD2hUYJlY2sOV+QIOFp/cDumQ2dBHBHxZN6hNaTtdFKjiOTS1jqWGlFe4R4yvNdjk7sVuylPstQAw42Km9Yj1olOASYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a81684bac0so55484505ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 09:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734800702; x=1735405502;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IhK1QMR3PWnCEv/nOJm/xHrauYj4RbJe0VEEeaJoGu4=;
        b=cwhLNkcEhEJOBjWh9vaxONLySpnWClgGY5ptusy8G58mNV++2+2q3pMAkr7x4QM0NX
         YM53thzzdC5LvU3n5Ia59znWy6OtzLEwIrzVSr5CVuz5Ehg86tsbyVEaB6yhdDKXBw9i
         aVb9SqS9tanXpj7KpjZhCbUSjrwQ7LeQr9n6Z3Fq9UZTluUo5yBey0V2TotzQDQ4rePE
         au5xuaz/PJkFNmoofXB8XfpkX1VvQxjTer17L65XBVDqnSqIgPsffi8VIM3YQgHMfECN
         4CCqkZ8Cue8H2Va1ew8BQnSdoYphY2Rua+UscXa/t9vJSeHaUBrJkzaZXziz1KZvs/Mn
         lqAA==
X-Forwarded-Encrypted: i=1; AJvYcCV7zGsx9h9pAV+XSglJz8cq8aQx3svR5lK/Q0V1EWll2ru0YqU39YBaQla5+pDL48mIP8B4vcX0O7/kaRuxRA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5LSlS4elyhNAdjYNgPjkTcWmYhoApSK1JEUN8n5Vqnz1m9BVP
	9swD4THLH1wLUGtIBk68yoVN77gBgTvtIlfLy8wmvrg3yhl0No7VtuyHEO1VnTuemcKnzR1MvBw
	H3IbOYxtTUDGGlKeYlbdW6ccVPi7nibFLYOfIjyByherAMfPOQb/oxuU=
X-Google-Smtp-Source: AGHT+IExi92azn4lifDupIxqBiYKJrPj1sPt1qi/782hookwYesmlQDbxaMmc05JJamMEAPp5TsOFmvNpuN/b0F+ixiTo1TNEBG+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20e8:b0:3a7:78a8:1fb4 with SMTP id
 e9e14a558f8ab-3c2d2f47732mr60127185ab.13.1734800702582; Sat, 21 Dec 2024
 09:05:02 -0800 (PST)
Date: Sat, 21 Dec 2024 09:05:02 -0800
In-Reply-To: <67633cd6.050a0220.3157ee.0006.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6766f53e.050a0220.226966.0012.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_iter_init_from_start
From: syzbot <syzbot+381eead9693b057ae73f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 7dcf62c06d11195e8caecd7b2236aa5b07e3ef8c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Sep 26 21:21:21 2023 +0000

    bcachefs: Make btree root read errors recoverable

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1232b2df980000
start commit:   e9b8ffafd20a Merge tag 'usb-6.13-rc4' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1132b2df980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1632b2df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=381eead9693b057ae73f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f640c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176fbe0f980000

Reported-by: syzbot+381eead9693b057ae73f@syzkaller.appspotmail.com
Fixes: 7dcf62c06d11 ("bcachefs: Make btree root read errors recoverable")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
