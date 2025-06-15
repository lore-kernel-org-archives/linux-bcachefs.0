Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA11322A
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981366; cv=none; b=cAo9pH3NcogM0tnN54Bv+nSPgct/CASD2divQOET43ESe6U5r46iqwv1CQqCJ55opxMvT7fkye2EfvDpaKEsGnzbLBsN4wIGK3nU1ZJ4wt34QNDp4ukVqp5luP2c6yV5VEGgHnM5CSTlk3vLKFmalQPsTwBKlLKuJZyIO1d9TSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981366; c=relaxed/simple;
	bh=dZIhcLUob/yE99krHJIG/yTSjf70smLK4p8/iQjCoPE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GHz5mZ2S6X24x4GWS/0jiVxsx0HU7Bg+PznDv7JV/nOS8gKl19dHXFSKk6OusSLH5xfhBaKJ5BUsNZ0R3xqvrgjiWy/e1AUomrwExqU/Ts3oTQdyhFLW7X/hV+vH3KI3WOV+wY9VtA4SSts5A8Ug6VJzga4HaJ19VZYe0B7XowQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86cfea700daso366034339f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 02:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749981364; x=1750586164;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocLTJRY+fhwTjCrhxf4nK0M6rGEU4j+JnFi0dOpX+ow=;
        b=MIa5s1YgQ0NMMtxUxDgWjwBaviSgHBeT8LYPJAbNLYEBdXez+ybmHMcypz4E4VyB91
         gGSXYEXBoffj7zNc3amUJmZAKA6Fe9v6dKu9/j4WHqwcniLRfNhPg6ivtqfUNr+6GVnI
         Yyq4nXmiwKk0MuspPIxPzNcU1s9d9m/wuHi6hLh09e5ieiTJD6nyHIIYSdgclLZ7uIlf
         4UyuArYFBco2OqP1MHL2sAgHYQKGMuIWYOA5gQbwW/8Z2Xhk20mEjYmCuHpaOjRcdxsy
         o5X9e3+Rq6LBXlRX8Fx3VyRTYc9DqhVDoO+SF5KNlQz/Yhbfw/LnYQiyR4YUg5oKNZKx
         3FqA==
X-Forwarded-Encrypted: i=1; AJvYcCUdDxdDNYOpA6M5BKZAGrp6Rz5bsWLSJejBJy0VlJcSQqg5d3HoJz986cc326N4nkLcuYskG6kVlk6qXjrXrA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+mwcSN/8zghzmKAQdCmZ6/FD9Kc+3HYs894ODhHwnBhWY7kv9
	fvOcMyN7Bsenf/nCgGiKQGEUE9fuC6y6jKcWoeA9CbTXmSkgbIRxxbZGZWMOcQQCEB7A8a27oip
	+aN09E0Vf0zGf50eC/DvtdjWtvBQQsWS36dlmD3dTIW7GTNLo6c0X4A2cqFM=
X-Google-Smtp-Source: AGHT+IEgPdrA2IM9OWgw6N/hK3nuguJZrWn9t3hAUZqWQkF7lKWgmWhh4O4vCROHhhDs8bphPbTlJovLhvktfgyPBoq6myrdvO2n
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160b:b0:3dd:bb7e:f1af with SMTP id
 e9e14a558f8ab-3de07cedfc2mr57014685ab.20.1749981364287; Sun, 15 Jun 2025
 02:56:04 -0700 (PDT)
Date: Sun, 15 Jun 2025 02:56:04 -0700
In-Reply-To: <684c5575.a00a0220.279073.0012.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684e98b4.a00a0220.279073.002b.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in poly1305_update
From: syzbot <syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, hpa@zytor.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d97de0d017cde0d442c3d144b4f969f43064cc0f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Aug 13 01:31:25 2024 +0000

    bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1683290c580000
start commit:   02adc1490e6d Merge tag 'spi-fix-v6.16-rc1' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1583290c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1183290c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=162faeb2d1eaefb4
dashboard link: https://syzkaller.appspot.com/bug?extid=bfaeaa8e26281970158d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1555310c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12810e82580000

Reported-by: syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com
Fixes: d97de0d017cd ("bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
