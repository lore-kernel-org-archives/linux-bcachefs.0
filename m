Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74E1B808
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753209845; cv=none; b=KD5DrVNfWo9rIsVKAaTCTlDVuR9WlqilJRjhpYMauLM+l+be0jjzBzP7tTeFwL9lhEUnhpELMh92ix7ywtq+Mme4nOESkGfZHxuZdoAxQ/jxf4htoNwMA666RT2MzdC/UExncIrbG0VRt9Fw1vITk2ADtHUss+Xswbzo18G4M9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753209845; c=relaxed/simple;
	bh=E5vg3Ya7hPJn6Bdyu6ITjxjWS0dSZI2OZEdim89RXEs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=f8K/YixgICNFt0P61f9buOfh2kNjqmir5LEVKY+qle2TP35/Z0Li7iDD3jOYSsuHbjeUc1u9yAc0dEs7ffEfzMIOC0uNAV92Z9UveDBdt91hnblcG5eo5KzwZvwpM+vYKqNdvBVSDTqo+KT39qIyMmWBzNHTF3uVe6O8mtmuzmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-87c33c0b62eso271766339f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 11:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753209843; x=1753814643;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4KfxIUheXLmXa0cAeGQ5PVJy109+sSEd/p8wEEDCi7g=;
        b=UWSfFB4IP9QnjFmkkTsEmtB4OtD3hS8leRAthzeX6st6UX4M0l8yqhkhkkDU0f5wJD
         SS3qfuO6I9uQmQsS7ff4tgVwU1/6oBUgT6zU6XwvZ0bIygX8SoLXQWESELu73Xy94RlM
         A/cGUm48QAwFDKw0ojz6bkXBlS23cuHsC1xxzVeq78QC7c7s8hiPsDiJq2WzbwIk88fL
         wJ4i8VGH2YM39sfqTw+rIdEOvncD4xVfWFRqhq+AE3TgRJsuyXAgXOvBqpC7JVaSl9ca
         3XEqdfUTYUQOIisG8W9qXZdU+qNyMxMu8h5aF4pmjOYVRgzz+YWEqVMlaoAHmvlgWBII
         46Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWTM/kRSXjlB5ZI8OwAAkG06GaN/RWRELGBsNIUonGNZfWGKl2qPERLR1Ny1ofI8caumUEFAo0O1LZysipacA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhqgcEOQopA0Txs1cUN/n+DQuNJLKmNo9w63RohIcrN5tcf9aW
	VSHjIop0PqBCAJKhDYOKBsJwC08QC/68jeisni6YdkfZ9Q2zTMnkmyy04ft8GaHfwQvTLG3fkF9
	DSOBj5PaJL/2zIxrsFBhLPc3d0rL4bBFsrnPWrgY+WVwvp6E5g64ipsaY4zg=
X-Google-Smtp-Source: AGHT+IEzuOahJA8GqCFONc6C7CxajVgGpS1Cwaq2T6kTILt6Gd+KhpIHD41mfKG1EKTERtxW6jdO4qZ4uraXCuCwuT/f1IlBY8Du
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:164d:b0:876:c5ff:24d4 with SMTP id
 ca18e2360f4ac-87c64f4e041mr38281639f.4.1753209843011; Tue, 22 Jul 2025
 11:44:03 -0700 (PDT)
Date: Tue, 22 Jul 2025 11:44:02 -0700
In-Reply-To: <i5jizyac6siolrwgsd6dtj4shebjophbf6mk6itete7rusmrxn@hbebk47xym6v>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687fdbf2.a70a0220.693ce.010a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in do_bch2_trans_commit_to_journal_replay
From: syzbot <syzbot+e3f91c76099a777cbf16@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+e3f91c76099a777cbf16@syzkaller.appspotmail.com
Tested-by: syzbot+e3f91c76099a777cbf16@syzkaller.appspotmail.com

Tested on:

commit:         9f0bcbdb bcachefs: Add missing snapshots_seen_add_inor..
git tree:       git://evilpiepirate.org/bcachefs.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=130cdf22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37de60b3108b6d8f
dashboard link: https://syzkaller.appspot.com/bug?extid=e3f91c76099a777cbf16
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
