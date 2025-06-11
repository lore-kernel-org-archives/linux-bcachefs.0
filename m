Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7320A4086A
	for <linux-bcachefs@vger.kernel.org>; Wed, 11 Jun 2025 06:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749624423; cv=none; b=DJGmMSYPKcLPeZCbijn7FbhU4lh+nfccY/0rtWpQQ4pyOK3gFh8SGjbTyZsDxycxiuH2hB509dnPS8FvHs7RU2q+XU2eycom+IMyhwDHXpF5W1InU0gofeF7hXM09me1lf7O6a0vHNb2Mv26FBMGqh9WuRx9Z95KdMd90s+oSVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749624423; c=relaxed/simple;
	bh=PwJ8H9eZhuNLJmD0SmVtkG+wVoyXdS2gv+ziwXoJL+4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mJQ1tm2UpMnvw08UC6XGmhK0Y8tk5jjmbXVWXZt07NQwaSX41HDXhEguC3Hx4k2PdAY/DZ579MG0+F7DtHaEZJoPaJZFKc3asgpW+dWxLEYiPqkKLqKEKOTtAUb2eJgLtD4JXQHqZ42aWGYfcsuAv0AD2DL4pUPpeDgmjsmVqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddc1af1e5bso145463695ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 23:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749624421; x=1750229221;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MewqcPGn/QokpfcEkkNeQEgd0jbUGHA58K19z6AhSKM=;
        b=iJAY5mMDTKtdy93R4/cnONFZsaWvSyeAO9IJ8SDNPM8iN56YQWBbZmRieghmhdFbHA
         Jjxs64T6Pi2GsCoX7bde2AZg4CDoQVBxp86p8kUX/iGqdPDqGp1R97H8LyBmSjFo07Rt
         F390b9ASsSJ78cxuBtNL2I/r4STEikCFImVpJfgMWRi+tu832XnzOCvXUw5Zh3IgotQt
         mFkbfq9Le89ikNAPr0QKzZWmS6Qto4xxRxbD1Ow6KfIFZ4LNX0x+7nqQ7aX9tV5WDUY7
         5AO7Ak79SyYHLDufkEyXAeQz8mgaheByu9noVRbe608OG/Us7U7O/0e29H1Go8JaV4yO
         yVng==
X-Forwarded-Encrypted: i=1; AJvYcCWG6cgj2rOvRAfJFSGw9L6K/xV+jOKESPUw4TRgsfhctrRHUefqVh3rg4ZflkYylynylFGrY6/+Hnql/by4Cg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXIxDHf/fmELMwFG/zptX4prJ9lO9OOh6IkCQluK0Jf7pEWTEp
	qgVAQaM3/mwNGo82396g6MiuJp/4uHv5wxP4gdjNHNkF5TqoO6Q3YQRfIdS6HMG0FdVQBtH954+
	gWhOZoOBpkRSaAS3+qWEKsGwrJgmrhT2r+Q+he0NHXfEr10swJg0OdFpOhOM=
X-Google-Smtp-Source: AGHT+IEU0X6hgxJuMlbG52LfRb7xkLAfxhgoWO2FaYvbH2006dQ0XfZLHXNKlTM6m7pa1LMgOPpaWC0xHZvEdX/HposVl04bZF/P
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1807:b0:3dd:cdea:8f85 with SMTP id
 e9e14a558f8ab-3ddf4300c5cmr22610735ab.20.1749624421733; Tue, 10 Jun 2025
 23:47:01 -0700 (PDT)
Date: Tue, 10 Jun 2025 23:47:01 -0700
In-Reply-To: <68488453.a70a0220.27c366.0068.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68492665.050a0220.33aa0e.0366.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] divide error in bch2_sb_members_v2_to_text
From: syzbot <syzbot+7c8101d4d0ba2eb511d7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit c5ae261c8095a37174e17eb13c5485cbd1b3bb20
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Jun 8 15:31:23 2025 +0000

    bcachefs: Don't trust sb->nr_devices in members_to_text()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c319d4580000
start commit:   b27cc623e01b Add linux-next specific files for 20250610
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12c319d4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14c319d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=846e731334efc0f8
dashboard link: https://syzkaller.appspot.com/bug?extid=7c8101d4d0ba2eb511d7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175a260c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1129e9d4580000

Reported-by: syzbot+7c8101d4d0ba2eb511d7@syzkaller.appspotmail.com
Fixes: c5ae261c8095 ("bcachefs: Don't trust sb->nr_devices in members_to_text()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
