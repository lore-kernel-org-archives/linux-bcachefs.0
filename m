Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46318035
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Jun 2025 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749365885; cv=none; b=rjjg87dVjRFQF/sgpQsfTf/5Dm5NY1L9T9CelU8a+jh0IlpQhwX5XyOFU8VkQkRdV5i7SEJoH67VIVn8+Ns0UoN0d8qfZBVeKd0Tg+Ryyhj0XTm5wV/CZrKqX0Yd8ZGk1iGNXoMV0lMon1uDrj9g9UC1WCMwNs8YOw3qps/F4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749365885; c=relaxed/simple;
	bh=hVWo4GD3VhvuKTf8CoKVWw7dN2hdQPhzrdo+CeBpT2A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oVeHihFJ4fhqqfIdcFKvsZrojBt2GpAtLuxSypAjCxM/YXuAD16Hqee/m0MKylttlWR7On/pCI2dFnmkowiiEyn92aMDvkjKv6K0447m0xdbt8ter3RNPYVi0QEysoWrZS0R3OL6HscesNm1KHs2LazCMyd98Kky7VeswW0hE64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddcc14b794so15842645ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 07 Jun 2025 23:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749365883; x=1749970683;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=84bg0eAOl4RoDt6abU4tGy6GN7YB+Z7N/qFLriE8C/s=;
        b=WPOfy0cLgApcILmoasOggy4Q4x6TYS/BXhbhmhMvKD6C5P+PgnyX6o1FTAyz42Tgse
         Ic3sWwwsuJXIHtjq8IXs6/mske6xR9VkoG5HTtXkfPP7aNYuzqU2MVMkfRpX7os4Wraq
         atE9E/asiWzTGNp5TUoUFPJMF4sOUIuzyqj9E/S8zLfAMESAwfKxP2d3WV2aONziS/Iq
         yjIntGg8xPiNZiPIbHSo+JRdoJ/jIJdk56rV3L+1KnfdD/XcpbAvS1yaousZFiKx/AOT
         L78C86fofx90Zy25EgrS5rcuPkXmf2t+TZYqN678lksZhtW7KUiOTII8ENCg7ZcfZkMG
         ahLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHA0MWuA274wJ2Bkk24zDYhx4FXWRQu/5FfOhYkWAbvdOxPLVrtNqnMfZs3+DZs++eGn+wc9wkDQ/bDz+1jQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3xOlLXpdA/9VKYgNEKv7boCki27uICJT8fNtrJQKqMJ3kgjtQ
	hEc/GMEZElEbHPOeGuKyCgb/be0rlAdRbQAwyKRGMDfGvrJvtj6Fn87xj0rBoHXYcexyuS2XzOZ
	oDHVYdNdDJ80bO9dV+KsiHy468NWIXbs2BONapnOfgBPkAuzt3nRi9vMp2nk=
X-Google-Smtp-Source: AGHT+IFJAyOgYOZCDWobVWxcQYMe9z3fAwvKf43nlq/XKaJo+ZcNMRmq2P3CMhJgBiuXH0Nhtimb2FbWPDDWOEx1ZdgN0jVi4i3f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c9:b0:3dd:d365:78bf with SMTP id
 e9e14a558f8ab-3ddd365790dmr80334435ab.22.1749365883085; Sat, 07 Jun 2025
 23:58:03 -0700 (PDT)
Date: Sat, 07 Jun 2025 23:58:03 -0700
In-Reply-To: <67a2b20a.050a0220.50516.0003.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6845347b.050a0220.d8705.000c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] [rcu?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
From: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, ayaanmirza.788@gmail.com, 
	ayaanmirzabaig85@gmail.com, josh@joshtriplett.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, paulmck@kernel.org, peterz@infradead.org, 
	rcu@vger.kernel.org, syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12fa0a82580000
start commit:   99fa936e8e4f Merge tag 'affs-6.14-rc5-tag' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11fa0a82580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16fa0a82580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=523d3ff8e053340a
dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119d35a8580000

Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
