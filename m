Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBD323504D
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Jul 2025 06:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752474726; cv=none; b=OnNNkwukQ1ok+G5Scmf+6Fs4W0gk/XKznUIezwS2dC118Q8sFseA4o2iFus2mt1OaFGa8hh+wBu03Z3mLW0Q6Dy9QWw+YOu7DtaYpIIKu0wet7hOs6fL40j6uaIQjd6ZBYxmbMVv6+z0+aFOU4q0OEp6wDgK0GTIEkT67eL0Fx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752474726; c=relaxed/simple;
	bh=va153gw+DLc+V8l0wOCuiPpTlHZUFObs6dMNjRWNt6s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MAvVertxkgIr78JmsPgOnTNGecYarEhkI006NYFMBBjOKB6BfalNzlL4oJmH4KGEYP7W2Wcb1vtjh5Iwli5OEmFqNUlfD5Z5CTeD92GJJ2rHWqjbSJqAoo8aR9JlA1NPH/UmonqCbB8wit5kBYhwcGsNew7+ofgphfMz0UIz9Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3df3b71b987so32625425ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Jul 2025 23:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752474724; x=1753079524;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Drjl5++96nBjNy31ORv6VBMFXWnYYE09eZaGN9HQRaU=;
        b=NHNmehy8zBNH93YnmTXNn45tP3mnkEZ91ZqtFOkERm9j7kiuhjAGdLUaREXkvhpIJa
         swuZZXJ3CSmr2FUvl2MUK+Qehtrrt/nXtHgccuHi4SILZNoJDfWsY1G+diJ/PM0qJTrJ
         ZFcyKeoEDvnV0Pt8Bbu4dfiDfiZhtn4+0DUnMnuH4imWxZ1FxjKI4pUfmRiVl9165yXn
         DssF4lVBDTSwGm1hfLUleAAUpvfMppFHfQYD3xXA7sgKA8FBSHjJbK/IN8TtmP7cF5oJ
         bMwpmRHuYsWAva/k4rvWzcbvynJuF998BVGl9fGiQIf7zZIFXNyiLLA+WulBj0jE+inZ
         Xjqw==
X-Forwarded-Encrypted: i=1; AJvYcCV8OvlgUZhPoX7gd7mUOABIqfaeyoXvYPWPORh5Py+t9SqLlA4+P5AvcJTpnuDP291rCdQ8as4veJhYlJTW6w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Zy+Uj5c5ArjX/38KlhBdTP2QCV3wlhqGkNvV9rkIzESdF3XV
	UotjOcUmLjE6t55kIaqwhqUEXzTgiZ5qWExNunrDY8PPo91pkTIRNYfRW40vQfYvmMKHXVMNsZJ
	IRAno7TTx55oRSLNtdM712wjJpJnw/OUO5jX0bbcqBN/4hMPWG+nQUIKXcW0=
X-Google-Smtp-Source: AGHT+IEzxbUzQ1NTjarPnNyh4tFQY4wQ80X1LiRAI+n3VkX1EtGFzpIRe4XCQY+Dp3HrM9KhAoJdpBn6DB0IMUY4abY91XljYtQu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2513:b0:3dd:ceb0:f603 with SMTP id
 e9e14a558f8ab-3e2541dc6d6mr120908775ab.2.1752474724219; Sun, 13 Jul 2025
 23:32:04 -0700 (PDT)
Date: Sun, 13 Jul 2025 23:32:04 -0700
In-Reply-To: <684c57c4.a00a0220.279073.0015.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6874a464.a70a0220.3b380f.004a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_bkey_compat
From: syzbot <syzbot+4908f37148402680dfec@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 263561649ee5875a922f4358e96d3deb17a91021
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Jun 7 18:27:35 2025 +0000

    bcachefs: Don't persistently run scan_for_btree_nodes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a0c18c580000
start commit:   27605c8c0f69 Merge tag 'net-6.16-rc2' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=162faeb2d1eaefb4
dashboard link: https://syzkaller.appspot.com/bug?extid=4908f37148402680dfec
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f9f682580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ecb9d4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Don't persistently run scan_for_btree_nodes

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
