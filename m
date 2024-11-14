Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2BD1684A5
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Nov 2024 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731602046; cv=none; b=JqUmxqqkSyaF/6hD2DdiafhahUK8Csm7u3EIU9nXeNqLioTfzogSYZiiKTGHJQ4KjgZDvEJ2vmaliSAinU86x6q4ejmB0Q9REJVh1yIM9ptwhD1EloLMgLtMH8Cz4q3JCgYm0Suq+ZDhMn9rAWQZQzX0cEUYWxaRTPasdgYep1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731602046; c=relaxed/simple;
	bh=JcJzQ7t6DI3TSKTqpMETY+CkRM5GDB0zfHkhOYTsoDQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sKf4MbtZVJa6hjoA0CH7pGPrKIYzC81MIKdbv9+SKvdbuh3aPmQWmE5dGQGfMkFVtz5oAwB2w3AEbSOELDKudB9Kr7fO0oC0e+i0qqJRuEsBNSlH8FJdeMPO7ddC53Nm9FslugVhFIK9z2ehl3eGE9QWxvkTh08XdNr5yAEOyN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3c3ecaaabso10659855ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Nov 2024 08:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731602044; x=1732206844;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sliiwqXBt0mwdYcuFGkwm49yStu9Z5ModNAGcjTzNX0=;
        b=jtqu5WfnpzmXhZREQqyew/+B+vXTl1C9IvYVb+O8cklM+JS7IH/Qmf2nYsPKdGv8qf
         4M4ipje86W6dRRpogR+60NKprB5AD8X2f89rzn47+9b+YPQAmADPBTJWJDGPLfVf30sl
         txBNyD4Y+O2cJwe4S+AhrqBeAAnFSnEllBxzYtxXo5Ou3h0ExZFhZXb4BvbzlLQ9Rvod
         HQwPaJXBFGoYkqBuZGIcMQyPw+LoEXbVuZqhkygNwv+UO8T3U858KSyg8FTfasjjdSIk
         CV73Y4iV4hWZXOMjmRQfMyO7+PnErIhsyA7C7gg6I7nU0rqVqGUeL9v+JpCMfmzNGo5K
         eU+w==
X-Forwarded-Encrypted: i=1; AJvYcCVULhqIC8DoXa2DvacB7oPFajRFXO+mbBe9BrW5RecQw7D1j6mLtqUaT6xhrJagEIeYTA6TowOnY24btcyAkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYhfs9VB4qJ2PPPrKZgx3bDGqT6+YcmzcroJpJGF7cEuCzp21c
	i5hPVdF2IXz+xVAjG3KESMU2IFO0P+04Kj/rl2lRDHSj7sM11oOpaYTWH2GEtia7Z11kvbhY0ut
	vhE0hSUkAuOdA1IeSy8EqdONtYYqvCQKitSlf/cZkH+T0fu8oGn3L6Mo=
X-Google-Smtp-Source: AGHT+IG2SzTvZQoN16E7Rlr6Eur4QhltQmI708CzNLRwHiHo0DfY6EnRE5Fles7mjM+HUm9jAPiE0Iq74wtgwnmvkHpO+Q1rqTIr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12:b0:3a6:e297:500b with SMTP id
 e9e14a558f8ab-3a70c717b2amr136002165ab.0.1731602043874; Thu, 14 Nov 2024
 08:34:03 -0800 (PST)
Date: Thu, 14 Nov 2024 08:34:03 -0800
In-Reply-To: <672b6e0d.050a0220.350062.024e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6736267b.050a0220.2a2fcc.0068.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_traverse_one
From: syzbot <syzbot+997f0573004dcb964555@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bf4baaa087e2be0279991f1dbf9acaa7a4c9148c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 5 21:37:02 2024 +0000

    bcachefs: Fix lockdep splat in bch2_accounting_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15abcb5f980000
start commit:   f1b785f4c787 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17abcb5f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=13abcb5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1503500c6f615d24
dashboard link: https://syzkaller.appspot.com/bug?extid=997f0573004dcb964555
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16172ce8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165214c0580000

Reported-by: syzbot+997f0573004dcb964555@syzkaller.appspotmail.com
Fixes: bf4baaa087e2 ("bcachefs: Fix lockdep splat in bch2_accounting_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
