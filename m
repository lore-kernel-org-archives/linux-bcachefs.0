Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F4C7E760
	for <linux-bcachefs@vger.kernel.org>; Wed, 24 Jan 2024 21:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706131363; cv=none; b=LUqUIgXBZMK9dUrZvXO3uiVjxXyhpWqg8f4ZEaBcu86vDk+nTTJiKq81UPaz3ESU8C66OhFrPC8Hhl8km5Xko4hwtbAW7dMqCilFkl9QWO922NZtp5vVuXyD7Fcp6UBjg24BAtxU2f2u/BHA/O1C6c4flqiFx+KuyHPHeh+5SEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706131363; c=relaxed/simple;
	bh=UtzHlezqecm6ddSc28B2LbZZj/RYgpz/WEoSpZS8hrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3HCfl78WzEuuacJ54Ytyr1POapznqkB1Bmvqc2b5OpWxUdUDpGMu87stgyu41CCxm9BUYUxtQB8YA2szFcE3n8yk82xwUbP4kra/YCMyHyxqJHsEirNM2QYu+QicsTfyV48plqqli/bobGN3mkdew7g9QUrrXsK6ZlvAjJ/ip0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YDr4q4pw; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YDr4q4pw"
Date: Wed, 24 Jan 2024 16:22:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706131359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FAfZf4WauMLfm02HdS1GROulAHJclOyFghcU0MJC4oQ=;
	b=YDr4q4pwhY278KZ3Ilmr3SqMJeQIYTV2dsV4d9PzCbHgjcSQJEHD6W2VKiaBWb90cno89i
	JHGcOqe2UK4H84DHmNxtfUfbLG7VroLR1K+IFdwZaJ5gs3YB7bj+BtGtTujWnZdQnVbdyk
	b+ZHM+80j+6cb1uctbVFpXLG0h9+WmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Petr Vorel <pvorel@suse.cz>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, 
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ltp@lists.linux.it
Subject: Re: bcachefs fails to mount loop device on kernel
Message-ID: <5ykyohhnlc7nkbz7usc5sqmluyl7wgyhc6frqmbo5kk4vhuu3c@kgzze4c35gsv>
References: <20240124200032.GA343522@pevik>
 <20240124205149.GA268968@fedora-laptop>
 <20240124210738.GA352616@pevik>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124210738.GA352616@pevik>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 24, 2024 at 10:07:38PM +0100, Petr Vorel wrote:
> > On Wed, Jan 24, 2024 at 09:00:32PM +0100, Petr Vorel wrote:
> > > Hi all,
> 
> > > bcachefs fails to mount loop device on kernel on both 6.7 and 6.8.0-rc1.
> > > Is mounting loop even supported?
> 
> > > [...]
> 
> > > bcachefs mount /dev/loop0 /mnt
> > > => Unknown command mount
> 
> > What version of the bcachefs CLI tool are you using? Is it distribution
> > provided or did you build it yourself?
> 
> Official openSUSE Tumbleweed package:
> 
> $ rpm -qf $(which bcachefs)
> bcachefs-tools-1.4.0-1.1.x86_64

Sounds like Suse isn't building with our Rust code - but, that's about
to become mandatory...
