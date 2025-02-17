Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141A419EEBD
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 08:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739782325; cv=none; b=rK0bqKxuplCXiwZmE6KauwJxYn798F3KGV2XDGCrLkK4ia3AzYEEdISY/fo0jcodDDsnaOLxcNdkSqQ5AYGJMCWO1kumrCJIUKOajZb3DEJyTEb5ZiRhPvLc176AKWCEORmziYfu1zhix4uNjoUQfFCUNNKv+5JMOpRPIvTfKx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739782325; c=relaxed/simple;
	bh=pTKM4ONs5xdJ/zoEznz6Tt7sfINMDFv0eJ7Qdu+k/w8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nznnteEuJwasD6IJudg93K0N2HIBMUdVSPmjPtruvptOGI0y6PktCC5ag2Vi2E8kQcfvUy8wkue8RhUoCpevw1Jqp9lmHkrRGP4/N8cVdZ9Zaej3+ewwEUGNpH28n1O/Q5yU21OJVM1+ec2QKAoqKaNqG5vXusLkyF/nkFDSuBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d16acfdddaso73990395ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 00:52:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739782323; x=1740387123;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7dkqt5TNcfumetUYnVjyG/hBirM8FVc1r3s0VKr1EU=;
        b=dmUS5rqvULwbnM9EQ5auT+dzopHJsp0y5EWDNus3s09Uk/ItnEvKCJJjcBR7+si9XN
         xpiHJc3qv3Fg5tQ6RNtyJ3LA843nCNp6T/1ZXo06+3ZaukwZi8GzOaJfpbUVUSPAihEn
         qAMavL+04nn/1pKCGw2VDoeQJXaqgp2E1bOOS2X+oE1W8crjvdlOEjEZ1vQS/LrJOsw+
         YzXiqxfRhz7Ma8WHROEsNStoMlfNnl5jNEs9NMT8Hi4Ltl7a5z1nML42AbjRsbjat/EK
         mIa7HR9N9lRnIbABqx/fGI7uE4oQddWUym2Gn5L2z8pUZqxJQN8FHPtvGlNw+69Qd1KN
         3vZg==
X-Forwarded-Encrypted: i=1; AJvYcCWXCRLam4osLUuUthxt7YZo/KQN1ObgAxrauTbZkv+woNcpf3ecdxq7aeWA7EPjId9vGdoc7A72DZgP5ayLvg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsgzsv1gAFXaLxJjfWkCTMRfTlMGrEB2vHtWE1HYLMNrB765c5
	sUOmfP++pC48tAOT+5CixnD4D9VG2yMsyrBlYJ1+ZQe1QrNuVlmNn0NCOq5iSpoj3gBViA+O0m7
	Biaxgu865g1UdA24FvGdW57d0CTGKH6uAq5Wi9Klms7aRcZBSWnzdp+c=
X-Google-Smtp-Source: AGHT+IFadkoA3rneb+/gRE8ngOLHkiIC8pgXB6U7bDf3vvzatGshGE1p8RJ8nI2S7qTrxqPWueCsvZB2taQHwL2K7O4VLxN/2L4b
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4b:b0:3d0:e6c:e9c5 with SMTP id
 e9e14a558f8ab-3d280974ff4mr90204965ab.21.1739782323278; Mon, 17 Feb 2025
 00:52:03 -0800 (PST)
Date: Mon, 17 Feb 2025 00:52:03 -0800
In-Reply-To: <679fb3a5.050a0220.163cdc.0030.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b2f8b3.050a0220.173698.0026.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] general protection fault in bioset_exit (2)
From: syzbot <syzbot+76f13f2acac84df26aae@syzkaller.appspotmail.com>
To: axboe@kernel.dk, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=171a52e4580000
start commit:   224e74511041 Merge tag 'kbuild-fixes-v6.14-2' of git://git..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=149a52e4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=109a52e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e55cabe422b4fcaf
dashboard link: https://syzkaller.appspot.com/bug?extid=76f13f2acac84df26aae
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e8b5a4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1155a898580000

Reported-by: syzbot+76f13f2acac84df26aae@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
