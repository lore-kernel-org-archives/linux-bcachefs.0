Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65828770FB
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jun 2024 22:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719008224; cv=none; b=AhWSPuFJcx1sUcjXy8ow2W/BtXuzNZa7Y0dUzVnxTS4XY2604EZCLDbkdcNL+zUIJm5NrWNJxjWxVZN7L5KUxqua6TeuD4eP0qTaBRjKk6O6LLy6SGJdFYL+wuP2o/DbdNx8aA3jJErFR3KP07j2ZfeFGmC34g7as3Yuzyy4Sxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719008224; c=relaxed/simple;
	bh=TnSlTjqwUYoXMF7xpWTfy7cgY8IeC4vWp5ZrJq8YaTM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jqUv9Ze+X6gT5uz60i9nYiReWVaPfyMyccFy7TuHBAwIReRR8apvDoBoyZVSmvZBLgvxV66m3iMVT3YykrWRWQ79p+3O8EOBePeGZipSMzoRXZ1jLOiwtoJDM1wWtaTHgGKg9DtAzX8oD0st7dKDqr0fAfkk4cqmiVdgPldDhzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-37613924eefso28899355ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jun 2024 15:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719008222; x=1719613022;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WzhDBRWwJ1VLwa7ll12EcMnW7G2/k0wBlm4KHTSpvsk=;
        b=WwQusT6dOgv321+/P5Rl//eiJ5eoXy7O4hbGnmLOcXsmxwRoalrRZvQt93CZHEEI/9
         +kd/niKBOLe/1rrPXwT/dsNXT4VJzmgehghFEBaAYzDRbFPm52zaUoEXb7JBP5GAUwsY
         /QjbPvAerYRRVwpfdXXVlTCtWuRtHxlXFGKEF/uLpUvt61XBIshBYGSXoQbL+1exAEcj
         /+9v0uuxQT4lDbTLjE98rVFh5xJ6YBeNS4dLpW1/CodQxZ0q/R/jrdQsmQDH5QD9vxO2
         MtkzJ+kyHIKnmfJ7j4uiMV0y5PnF4tHtZUibmQqz00nw3ShVDsvyQM/IG1dqNXMv5fSS
         SjaA==
X-Forwarded-Encrypted: i=1; AJvYcCXRWsAGWZi+PWwG6LG5LMb9aexYyqEkfRoOHEZ3LJnB2TlbUwmJDtWx2VvP5ZX/E2v/gosAF8OzTTI+TiXD8m4L2cP1rv0/8xB8GP88Fw4=
X-Gm-Message-State: AOJu0YzC73WovmU3Fxs5q+JoMn0y8XKH8h0Dr7nhBj6MQFPBxiHlJ1jt
	HaQkqJss7c7RCbXjDkkwHH5VbkMrtk+3L/Ex0h8sX0xp/LjJUd3kCCeLBMkOGEOTrKy2CX4a/13
	UkodZXD+b63sSYs2VCmqQiywL2a0wHHoiH2ckPijpo80ySmwODcj0fJM=
X-Google-Smtp-Source: AGHT+IExnzpznCLMVa5YEOvMddL6ZtHebHjevxgzgt+MvgFNjpb8SsfjwEbCP9mvVfe8x0jiJpNhh6ltL+Q01pOnZRQp3BEjIDNY
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c4d:b0:375:cab8:f175 with SMTP id
 e9e14a558f8ab-3761d69f09bmr7250985ab.2.1719008222647; Fri, 21 Jun 2024
 15:17:02 -0700 (PDT)
Date: Fri, 21 Jun 2024 15:17:02 -0700
In-Reply-To: <000000000000aa7cb106196f6883@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a267d061b6dca15@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_gc_mark_key
From: syzbot <syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lizhi.xu@windriver.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 103304021e54bfb5cab9ba04cd5ef0dc2bf33888
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Apr 20 02:44:12 2024 +0000

    bcachefs: Move gc of bucket.oldest_gen to workqueue

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=162879ea980000
start commit:   50736169ecc8 Merge tag 'for-6.10-rc4-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112879ea980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12f98862a3c0c799
dashboard link: https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144f0a61980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cab6a6980000

Reported-by: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com
Fixes: 103304021e54 ("bcachefs: Move gc of bucket.oldest_gen to workqueue")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
