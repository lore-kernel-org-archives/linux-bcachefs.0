Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C29202997
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Jul 2025 20:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751920144; cv=none; b=CoRKMEsYjtfvVE27pkAtxec+TheLwrg5urDOJzPZYpnbfKdBs3enOotuTd1pxlfWBfV/nizPQJzjAZwSD1hM+R0Mv6+9RgE209ttYeBvyVk1mArLwJsasCFg04c6xrLA4mmbYUjUXfKPvXNFZFeJgxvzorLHZ1bancc8q/ojRNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751920144; c=relaxed/simple;
	bh=Ot02nqPa2ouHZW90wl6dQuaul5Pxf/vDsrQRSgDI/iw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=XXTc1SIHqRCgqk60tPoCsFyExvBNiuhMM+fHP8SwZyaVdbPnWfVgn0baTYBboxHjaaVNUJuCXOWbBfq3z8mk1qelryq/gsNu92aUydyyb/h1n7kdXrryBo0MDIJPCI9apo9CE9tY2789CtLqk7n7hDrK4fAW4Ie5+xJ/DFOfSIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86463467dddso356979439f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Jul 2025 13:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751920142; x=1752524942;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91bX3oUdnFkBh3AWeRAT8/+UY28YiWDPjER4C9ZXoqM=;
        b=Up/jfOgYCqzOapOCmRJuPP+B1mwjatUYPP3lA6fPAj7wnZWcnTYRw00gbAf10xoiQo
         B/2toMDgYJqrnyzGo8s7wB7CU237d88nCYsq97w/i2W+vqykkvVpL5KoZ4BxNVMw+KaE
         HF7aWfCkizy4+F7VEo+VRwqJnZgALPy5mEj1Gc/hLA8v4givmD3zvVV+ys3pJZSo5f+I
         L3B0hHpxHxwRYOiBvvBLGHITyl/fqWlmFJ8T4GUCQ2ev24SBFU3kjfvQOwow4mY1XVHI
         EyXckgXWBBVzOcMJx0lgMn6rT1eFkOAeVc6tyVf7zvDqnD0zj057i0yGtiJK3RnMp6vV
         oi3g==
X-Forwarded-Encrypted: i=1; AJvYcCWViwqgcmFVYx+AUCuQo752uV8kbLVqWlL2WrFz5lzredW7w/q/QSi0WI/mQl373oiVlgY9O1JGfRIIxoKCxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb35zXTmIMk5qQPzZaWKfdvIrfYANUCiTiEWJY0PTu2hxhR5Gm
	DM6bFZAhJ14TLKUaWIzhYIWG5361hn9yiEIUIHJhwq77zQHsO4GIgERSQoC6E31OphCxeH/CzDj
	MiqyTyD97x860Qb/oCJs6Q1SYNPswUJTZOnGx0OEamxymoKnxL0fIb+kRN90=
X-Google-Smtp-Source: AGHT+IEbhTNVlC0ZTsaebcDui8mxJFU+YnwEblKdyep073zKGmZKVQEUYTykOVv7m/b7JvfHQgW6v9hQzDrk6VWeQSQWmGU6SRAE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:360d:b0:86c:efdb:6eb9 with SMTP id
 ca18e2360f4ac-876e4904de5mr1025624039f.10.1751920141991; Mon, 07 Jul 2025
 13:29:01 -0700 (PDT)
Date: Mon, 07 Jul 2025 13:29:01 -0700
In-Reply-To: <67f76c11.050a0220.258fea.0029.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686c2e0d.a00a0220.6237c.0004.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_str_hash_check_key
From: syzbot <syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com>
To: contact@arnaud-lcm.com, joshua@froggi.es, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 757601ef853359fe2d57d75c00b5045f62efc608
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Jun 8 15:40:00 2025 +0000

    bcachefs: Don't put rhashtable on stack

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15319582580000
start commit:   a79be02bba5c Fix mis-uses of 'cc-option' for warning disab..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bbffc3b5b4301e1
dashboard link: https://syzkaller.appspot.com/bug?extid=843981bb836d699c07d1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f8c1b3980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177ce574580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Don't put rhashtable on stack

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
