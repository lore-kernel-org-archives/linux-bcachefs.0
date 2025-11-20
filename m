Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E17228CBC
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Nov 2025 02:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763605265; cv=none; b=sHnUBpNuO4DhK6ghIQ8fKTp9C8JUfez9I49ZAG9EFQEMoMJoE69bf2fRgCzv32aWWRoXr9yca6dxv54RLgSu9HmNU0RFwNEGyFDsogU/oNb+vziCy+elmKrec3AMYReh6NgSdd7qabWqk63ChaHjy1NjndnJvipG2MPLf95edmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763605265; c=relaxed/simple;
	bh=qYFtz9sq9FHQCtDr7Wido7uYq8JiE9tF7tkQL69uxx0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cDQO+JufUf4+ZrJGkbXRttgUIQpY8d7HdcxlVFAdwVJTeEMuwoixZt7w0JfEi/uSgyp+PTAlKsxHlXkUws9hfMMJ2hhwnQGK09bZuAD6TfnPkSlHkncH7tJsuG5C1sVQkfzJ+4p6U1Y0AEL1vnqM3/SY9rrXW469f0R6Ax+5A5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-433795a17c1so5087875ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Nov 2025 18:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763605262; x=1764210062;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnz45eIVYo62bL2zw113MkJVSxwXfiO5WR0uqBoHfEs=;
        b=nh8r9VFmnXBRKfJ/UXmgw4ZiwPMVUknndRs0AcZzJFfD+yTuL5gUCZNrUKH2R5uoUz
         yzcN78zHXyeL2RqgWYNZ3qLC7TsPrN8WRN7qA33y9ehEhmMKsOUpeI/0rbaJ03aV010o
         9SyXsMAgLEUiNh7omOTd1DxKO4NjAkfRR1Ug5B9wz7a2bY1uawN6bK4zO8RF8mK9SGzP
         RXu2auQgaqZtHzSBMIX9kR5GbyKm9j9HSq8AHmb9Dy4e0bbn+g+e3hDd3T5TmrfjMEZT
         ZUFa9z+5KL9eHaA5xyZI/tB+vZ0SM7pGGBz5D7/uALaW6OPvixMEf4SwS5xPnW2EXdiz
         65tA==
X-Forwarded-Encrypted: i=1; AJvYcCXLWJynt01il/DkOmnvegOG1pFrVfst/t51AW93qVRKZ8E4F12QUTXlafrC6l2gotshKw6gsjhZgnPGmQBOBw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq8aehNiGfs0s0eICBEWkRjiAbtB1VJVSAc4q+UBZMVOBEfGdp
	9raiAtPebRAk4JMZYol/TO24WeKUwxa90eA/34tKS+MoEkHyyhg0HAIJGkpU8ZfyR+hj4jgJYKp
	AzEvmE0GiYtv8QofEnpRtIA19OXdiEPaNMscfb8opcZYuT2AQCEwmUXBXBgg=
X-Google-Smtp-Source: AGHT+IEK96nqqRGxxiaH91dikX9Wuj66Zu9FDgTs5BgWMByHDrn2IIW9MNpJD0LYDL+hCzDcUh/fq7ycbH1BuRuzyUHcTD2WtMB9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a0f:b0:434:a86a:f162 with SMTP id
 e9e14a558f8ab-435a90323camr18087325ab.16.1763605261872; Wed, 19 Nov 2025
 18:21:01 -0800 (PST)
Date: Wed, 19 Nov 2025 18:21:01 -0800
In-Reply-To: <6879a305.a70a0220.693ce.0058.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691e7b0d.a70a0220.d98e3.0027.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_run_recovery_passes
From: syzbot <syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16515658580000
start commit:   90d970cade8e Merge tag 'ata-ata-6.17-rc2' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=98e114f4eb77e551
dashboard link: https://syzkaller.appspot.com/bug?extid=c2294ae43bae606e3c7d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17728ba2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e6c442580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
