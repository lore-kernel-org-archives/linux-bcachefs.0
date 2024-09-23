Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F919E802
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727111959; cv=none; b=YvBCCxtjl+6nOZtBVA57A/XuaF4GZrxNCh8X7ENyFAzqn2SrTF2mdgNQ/nAq1Q1WvgExAVPql8ZWILyuYAQ4U22Lo5B3VwG2WJCEoHes+mMRHDO+mDE04xuRdXqImOGIsBdFEmmX2G7hH5zG5N1p8mZfStxpYTjlEGIZmXrIxrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727111959; c=relaxed/simple;
	bh=8CzslkZb0sUznqump5kOXrXFXRvqNxrUKdCua2E89hI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GYmbPlaywnIeB+//ZpwjGLY6ZvbKpnAgIxQwG8XvD7iOtNSe0wGzCP9W65Dsbi64+47Qtho1fywNQAV/ju6E9XH8Nyq7vcUcKIvdrb8qj9kFOMJNY/qDexItHXJUeTV7PeLGskvw3nbI5pgt2LcoQFEscLhxrJtyuALRQyQjqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FELANVMh; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FELANVMh"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a8d13b83511so563228266b.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 10:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727111956; x=1727716756; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/88YtmKHLqGAFWhvYULFA4aDXhjl5wiNzxfGpypDRso=;
        b=FELANVMhvlxmMXInbvxWIe2kRpvXyATIfFMHjtpWNTN994exfey+c6yy5mw7hIN986
         FbqiIEKN3KCHWbu98L7mE5sOmki7Kqp7viy/eroEn5XewA2L/MjRQG6as3km2Aj+c5rL
         EBJ1pq2eMclhAPHWWPzzcpNdDC0Kwjokpd7iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727111956; x=1727716756;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/88YtmKHLqGAFWhvYULFA4aDXhjl5wiNzxfGpypDRso=;
        b=Z1/H7XC4dcxNgQbArtIy1VmKtUHPKZMowkvvb0VcIxPG9LZK3qZoX29Nus+jAsv1Ls
         W+nZOLLw8P+su11CqmLrqJQF6W4Y9oV+7qS0e7JllDtAv+AMNXys5PhG7hbchAH17aUj
         Z8q5XtvmB60hXba701LuEJqacvlg/J6QKet6glNX9KpWfvaoJpenzR+lL2bM0tx+Ih30
         wKbJF1TdZ2Ckk61s+wzQCix6SG8dolOe6p7CU+CtKqeKyI1HKVfq6KXlrnFKNiSEQYqX
         Pl/xxRWNrtMmdjymG08jh5zNJ3AwvKnW/5sqnekJjWKwpBRQSO63m+3RTLzeFE4rFDUK
         CaXA==
X-Gm-Message-State: AOJu0YyM0bkpfyd0n+y8lPC7n/HW9kJUYibVilGcVjZlKYIEE+GTSwYP
	k3cEeO+gzqj66WOoea3fHin5Avmj8XgV69WAm4alAwhyq+2WUSNelLtiGGKjfKuLtgt7+nMw+vn
	jy8s=
X-Google-Smtp-Source: AGHT+IFzQYGHY2HjPSDC7C347yP+p5l7GgIH3ZfKtbOY3TaRTq1pM9pNywdm0IMYPKOlr7BeKbF1zQ==
X-Received: by 2002:a17:906:f5aa:b0:a91:15dc:31ab with SMTP id a640c23a62f3a-a9115dc3314mr115938466b.53.1727111955743;
        Mon, 23 Sep 2024 10:19:15 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f42e6sm1250441766b.78.2024.09.23.10.19.14
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 10:19:14 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d13b83511so563224066b.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 10:19:14 -0700 (PDT)
X-Received: by 2002:a17:907:25c1:b0:a8f:f799:e7c9 with SMTP id
 a640c23a62f3a-a90d566c9bdmr1174018266b.2.1727111953883; Mon, 23 Sep 2024
 10:19:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
In-Reply-To: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Sep 2024 10:18:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
Message-ID: <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Sept 2024 at 12:28, Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> We're now using an rhashtable instead of the system inode hash table;
> this is another significant performance improvement on multithreaded
> metadata workloads, eliminating more lock contention.

So I've pulled this, but I reacted to this issue - what is the load
where the inode hash table is actually causing issues?

Because honestly, the reason we're using that "one single lock" for
the inode hash table is that nobody has ever bothered.

In particular, it *should* be reasonably straightforward (lots of
small details, but not fundamentally hard) to just make the inode hash
table be a "bl" hash - with the locking done per-bucket, not using one
global lock.

But nobody has ever seemed to care before. Because the inode hash just
isn't all that heavily used, since normal loads don't look up inodes
directly (they look up dentries, and you find the inodes off those -
and the *dentry* hash scales well thanks to both RCU and doing the
bucket lock thing).

So the fact that bcachefs cares makes me go "Why?"

Normal filesystems *never* call ilookup() and friends.  Why does
bcachefs do it so much that you decided that you need to use a whole
other hashtable?

                   Linus
