Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3F33BBF0
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Jun 2024 21:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719091416; cv=none; b=IQAp63Xsj8QmMB6Ymt0Vm/5XfIJV3hObavdKefEjNp3adDF5vr1FND4/uViaCJ7WyS7uX1uc2Lhnz0JcdWk5vXQJ6EvGAXbqDF/kh+fzWIioOpw0oPw+lzVtdsub8Z0qrvIGob6eOeojxc/EvFlK8KDL8p/8iRpAlXxkA5ViCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719091416; c=relaxed/simple;
	bh=UFV+r/FdDgjmW/Bs3itLM9/eqc9N3lhVHlLcntS/llo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMoN8TOb4hfhD87AF6fhU88LTx6X4WY/JnPYCNHbX3vabYE0uPNOMYLgF3AYTGYzT1lNTt7RW6jGP5EwqlQA0XyvgyKZIcoMp9gZez2AXsbfjULdhF43qXX71rEYCifJNIm4u9EadIUZ2//5fZn5ijRpG8Ck7rU5o75osB6f47w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i8Tic4gF; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i8Tic4gF"
X-Envelope-To: syzbot+ad60312dc46671a69480@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719091411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UFV+r/FdDgjmW/Bs3itLM9/eqc9N3lhVHlLcntS/llo=;
	b=i8Tic4gFZr4ge9c/KmD1Kbu85leejf0lLwal5ZVUvlqH28ZmNFyU0a4vlv44rWA9Z63bGt
	wg+JavM/Ua+kWQD2wEBaa/EA6oiC/WeV+nQdQ/N8d+JAQ3WsRzjkem9VfLJM+KVU77K7tk
	TOCmiVDbN8DCmy75ohyjbQX6pU+Jmkc=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Sat, 22 Jun 2024 17:23:26 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+ad60312dc46671a69480@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_ioctl_fsck_online
Message-ID: <dqc3qdllll7xcvsc3k7fpwumigi5dg77zxzdd6aq7hg3vshpe6@clcu2hyaz2n3>
References: <0000000000009fb1e2061b802aea@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000009fb1e2061b802aea@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix freeing of error pointers
