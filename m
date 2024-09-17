Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDC170828
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Sep 2024 09:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726566664; cv=none; b=uTP4c/3L6qnrt54P+7bS8oyqEp1M569Y4NeXB3ou4C+LUHjqjPWc2OYuAGJlcgaNfL55gi+3o+jahJfCZNDdWlkF4idDGjyfSXPQu5cdAYGj+ptcP3Al97p8LD0FVddSo/4jIUD49sLQ6xZKqA2DgTlchWRjDYLE/aidF0c+ZK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726566664; c=relaxed/simple;
	bh=d+BFDkFojviuUYyTlF8lf53Jk7wMgz/eph+lTUjGNJw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=s/X7rJZIspktyeOm5hcC/vCKDgKKdxi/VruTwkJtPZHK+xuv5QhSU28SRRC4B5KexbhC9EroYcpNEIzsVvBVug9MzTKcbQS9XTmk6LnxIG/cb7cxAbtH2RTBwCVawVb+9KeIwE+Ib+v83Up5uxk924sr2OzF05RsMz0LhsqjJdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0a2c95e81so18110015ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Sep 2024 02:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726566662; x=1727171462;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1WAEizX9Y1SMbjSDqtNh8j+ktqk2hMLvxIFTpNMvgJ8=;
        b=wUUxVnx1kzJLSUqKE23okpGgn6NfeU94dLuw/JBbcTPTIyT+WXk1gIUrmb1HZrWBM3
         V6j2p7m10l4WKvWAMHsZNBmn5XtlDikh6vesqvZVa/ASpnLx4ZzNlif2DEtwZx4CPsCF
         p2+Mlem2hpPBmVY2CS+CYrKAjiwWFbIcZ9Au0R+LwovlnAw4Y4nQxJaqRbn4hB4sppVk
         eStaVu8alRjXZHGhD1qj3MyZpzm2uoSkprcpb5ETqsr33LKkwRqAU++KNYCqNB4o+nSb
         L46vs1QtiFwb7TO8JvYbNSvd302+feoj3Y+au/3MMbUk7EDJN5A36u/aNm5UL7ohy/be
         To6w==
X-Forwarded-Encrypted: i=1; AJvYcCWZTA9CPahX3DLg+xvvQvFOp/+aX5XtOo1xGNTLlGuPNb55jzEpUzHFDFXMEEXBEYAoyQUstlao947S6h1wVg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn5WjY2iKgQtD1odpULg4cjj2/ZINYU8vcbsNF9G5s4xnWIWKx
	zT1SceixsUQHH9LIaeefdC3gql2qD711Pfzp2VIdrsEM7hrQFJ/d+AGKscWu05DXHcV4ZM+F0je
	+VPATVOARF+SyjyHnz0Zw2+CRVWFz8lunOglI9XFpAgrPLLsokB9fK6Y=
X-Google-Smtp-Source: AGHT+IElAEl5pwEDniwyOyW0Nf1KrDJxFTCIQQfsNBJMaH4x60gTb1RTLqMDHomFXNXjut1/m+HvyRhTOj6ZfZj3XtZ3uDcCjebb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c5:b0:39f:5efe:ae73 with SMTP id
 e9e14a558f8ab-3a0848eb2admr187448595ab.5.1726566662251; Tue, 17 Sep 2024
 02:51:02 -0700 (PDT)
Date: Tue, 17 Sep 2024 02:51:02 -0700
In-Reply-To: <0000000000006304400619bbfae2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000095b8f806224da030@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_copygc_stop
From: syzbot <syzbot+c6fd966ebbdea1e8ff08@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f5095b9f85a1674a92d00e7ab466499a8ba49ce1
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Jan 2 00:42:37 2024 +0000

    bcachefs: dev_usage updated by new accounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1256e29f980000
start commit:   adfc3ded5c33 Merge tag 'for-6.12/io_uring-discard-20240913..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1156e29f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1656e29f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f94136b4da4e897
dashboard link: https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10936a8b980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10bdd7c7980000

Reported-by: syzbot+c6fd966ebbdea1e8ff08@syzkaller.appspotmail.com
Fixes: f5095b9f85a1 ("bcachefs: dev_usage updated by new accounting")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
