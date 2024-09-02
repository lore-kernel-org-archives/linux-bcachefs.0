Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664C21E51D
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Sep 2024 10:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725274386; cv=none; b=OqR5EzdYwlqFwKWqdBBX1tLvL9ks0lm+uqUKClYYN2NKLWvkfY2IiuEvKhN5kb6nGuFuvG7OnNhLKJVeRKuHRAkE0ggdzwBcHvUhqHnKFssXMUxg7olPgGjjTAG57hqfv+NG4GZAIVyXw7UUK1WCrJXnWwB0xpP6uQvHkc24PDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725274386; c=relaxed/simple;
	bh=oWhd4Rf0zHHpbpst9n9x+vifq8Bnir5pNyheMKTt/fQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rqFg2XvO7Q+ZwIHgS5aQnQM/H/DrogBEXOmy5Jn248gOZDaugVdcFp0mGTXp3kl8ZIQOqm0pSyhfTieY+KCY2DiPfLGi6AZX4g/3ykxWZPS/E900ekCpNwnStbiJS0IHJDj0IFCGruSaa8nlfIEe3h5G/ln3ULQQqx14rdRdX0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82a217cec33so424657139f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Sep 2024 03:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725274384; x=1725879184;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRPnLHsiu9UwQQIF05EoEjumpQG8FgwHNRyv/yjcl8I=;
        b=vUGfy6oiA9QYz5a8ZWMs/qP6+BjG6bFYgW7ONqp9dthzXRiIOg2UaIWLaLx2zvfPs3
         14OttSqlmf8jHSbFhabD6O8ZNw3c/insQaqVlXRBjvA/OC/23zneVK9AJkVz3fRUP7zZ
         EXZQa40MznZo34w8a6qHfMDm5N8XdfWUwrEAlkJyzu4k/At/VYd2TeLOFUSJb80Bl/nT
         mVRjxoRdm3PTHcaL6p9PSxJYYLqdg2TiEhNFPj2NlknVk8VsKM9O6pmOcNBE5MbmmWso
         q5a67kdmn5H1Mhrw6hKEuo/f/716W6lMd37YM967VohOUiafDuNMISUt9hyzruHf+0Yk
         VI6g==
X-Forwarded-Encrypted: i=1; AJvYcCWm5dM6UbuGHq2jDmMXNdmOv3ahAe5CF1mSP1NNrjYbWH2ftmRKeiDlAQYuRgfTM6Xao7mBOUuHdD7jLt14PA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzeFDxYGSBW70Cc6fM2p07xVRb527UvDV5/otJFaeX7DNhpkkiz
	fdCPxNMCeDcU8ATy0nhSeDExb/IbMoEvipodhVWdzMbQqwBGNTeXn3UUtbwRpwV8tS3ORfojscv
	f7Qs5ULICbCHq5GAOAgqEd37/G1NJRYxaE9t/TAOTiA0Eia0OFV6wiMw=
X-Google-Smtp-Source: AGHT+IHZrX5x+ddAmSe22mb55IktNZwUNEVFFkWhX/k6jYUcdMLP4AIIqXZgJiGhfVkY/uP4CjKDxwJZ4R27HzDpYzvkC1APeXZu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1489:b0:397:ca8e:d377 with SMTP id
 e9e14a558f8ab-39f40e1f884mr10470655ab.0.1725274384455; Mon, 02 Sep 2024
 03:53:04 -0700 (PDT)
Date: Mon, 02 Sep 2024 03:53:04 -0700
In-Reply-To: <0000000000004169f9061ceadd8a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d369bd062120bed7@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_journal_noflush_seq
From: syzbot <syzbot+85700120f75fc10d4e18@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 2744e5c9eb1a1090b5f61c955e934c70bfe6b04c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Dec 27 23:31:46 2023 +0000

    bcachefs: KEY_TYPE_accounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10761263980000
start commit:   1dd28064d416 Merge tag 'integrity-v6.10-fix' of ssh://ra.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ace69f521989b1f
dashboard link: https://syzkaller.appspot.com/bug?extid=85700120f75fc10d4e18
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120f9c9e980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158b8d69980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: KEY_TYPE_accounting

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
