Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3C28371
	for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jun 2024 12:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717935844; cv=none; b=TuU2npLU4yCxTC2oZfi5sx5dYLHapnBQUqvMFCNFNESrcnvkIgm7t3mL9aFJBxvexgU96gBbzswu6Zpn6zL8K90j1equge3glfZBZPkvbXDoDzzN859UD6R9uckjzkA87ushTopbA91TBsNEGT+kD8cqeGVrhmkSOvySM7Lc9so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717935844; c=relaxed/simple;
	bh=Kcph++9N+3JuC505njQvJBuAr5da5Ttc2ke9K0Xt9f4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KMzixc3AtQGNXwPUG+sy+GuZi6K2OE4XeGMphi1J7jczi1tqc/hJo7saY6fdxgO+d4ynRZEv9f03sHmSwybkJr0VD097mEoeTEfm0vWCgKht8rfoPxkjpTth96BtGECIEo1NavNeZ0Ve4ox1+WuwDNjvj2VKJKdQmTsiBE2dDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e91ad684e4so441694539f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Jun 2024 05:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717935842; x=1718540642;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sLqhBcU9jwlvP/mrXCqjLuATyuFlQ7094WyS5VW+rN8=;
        b=ATwiZL5B7V7NgiyqD06YT9LmF3nipJN7c/nVmzh+5VDwc/6RIGV1svC5XC74+TGcww
         Ay0ZKwW2nwqJ6DHyfHZdOEEagx1ViXT7/6NEbpL5qYErmRjng6wSzGO8ircGLrBpzvvC
         MCKII8Hm52II0LtNWBxFjADQvuRS6qDS6Tmh6UYJkq1W/s5HHHBQz8gBtzV9/m9S9vDi
         n+Bh6D+3DCdJYH30S43bz6oDWOQ3pdf4pPYK78lufXO/5bQShM8V/mLkW2PeXfYcsLJa
         Rxv35Y0G/hV5YQgd6DvaX/DBbDHno8onRFcwUJ9JoACPE59G8bs8SvA+b5uPtqNr6xhV
         6Wqg==
X-Forwarded-Encrypted: i=1; AJvYcCWoQVO5Cp38/M73XuBsM4XTQXwY/o86htzctP+xw3fpNhgTiKxF+2djadtIzOQk67FF/mGyp9gIt3abuywuBtzLMrdQcT6thre5afTbnlE=
X-Gm-Message-State: AOJu0YzUr3EHQZQK7o4H5Ue5+Npk4v6qunjlcnkuMmkY47pBmx6XGkGd
	EuQ7Luyr3QGD0QLw2NhzVUxPDLwhI3EPJqNHHdovd8+bRQ8N0Nr4YmrULt3F95CzfZeJtP1gGax
	1wZJqccM36g+1CK+/3/Bu1m6cAreoQWVnXhqX+M7saLex051jPwJ/22k=
X-Google-Smtp-Source: AGHT+IFvfnC0DzHVjfhCUDuU7hk3k/fPKOm2hiULta9pJspJ9sNRGRfIulLgrGuf/01F165Qv3e/tUklQ3pkaNxQidGQq7Ib1Lz6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:270a:b0:4b7:cb85:c0de with SMTP id
 8926c6da1cb9f-4b7cb85c294mr217708173.4.1717935842167; Sun, 09 Jun 2024
 05:24:02 -0700 (PDT)
Date: Sun, 09 Jun 2024 05:24:02 -0700
In-Reply-To: <0000000000008160ad06179354a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ea02f061a741be4@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_recovery
From: syzbot <syzbot+05c1843ef85da9e52042@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 7ffec9ccdc6ad8356792f9a7823b1fe9c8a10cbf
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 3 14:55:17 2024 +0000

    bcachefs: don't free error pointers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13191932980000
start commit:   ddb4c3f25b7b Merge tag 'for-linus-6.9a-rc7-tag' of git://g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=05c1843ef85da9e52042
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1464ea2f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130db31f180000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: don't free error pointers

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
