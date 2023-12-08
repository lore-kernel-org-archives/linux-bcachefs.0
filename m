Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AAA11D
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 03:34:49 -0800 (PST)
Received: from [141.14.31.7] (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6289A61E5FE01;
	Fri,  8 Dec 2023 12:34:29 +0100 (CET)
Message-ID: <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
Date: Fri, 8 Dec 2023 12:34:28 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, NeilBrown <neilb@suse.de>
Cc: linux-bcachefs@vger.kernel.org, Stefan Krueger <stefan.krueger@aei.mpg.de>
References: <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
 <170199821328.12910.289120389882559143@noble.neil.brown.name>
 <20231208013739.frhvlisxut6hexnd@moria.home.lan>
 <170200162890.12910.9667703050904306180@noble.neil.brown.name>
 <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/8/23 03:49, Kent Overstreet wrote:

> We really only need 6 or 7 bits out of the inode number for sharding;
> then 20-32 bits (nobody's going to have a billion snapshots; a million
> is a more reasonable upper bound) for the subvolume ID leaves 30 to 40
> bits for actually allocating inodes out of.
> 
> That'll be enough for the vast, vast majority of users, but exceeding
> that limit is already something we're technically capable of: we're
> currently seeing filesystems well over 100 TB, petabyte range expected
> as fsck gets more optimized and online fsck comes.

30 bits would not be enough even today:

buczek@done:~$ df -i /amd/done/C/C8024
Filesystem         Inodes     IUsed      IFree IUse% Mounted on
/dev/md0       2187890304 618857441 1569032863   29% /amd/done/C/C8024

So that's 32 bit on a random production system ( 618857441 == 0x24e303e1 ).

And if the idea to produce unique inode numbers by hashing the filehandle into 64 is followed, collisions definitely need to be addressed. With 618857441 objects, the probability of a hash collision with 64 bit is already over 1% [1].

[1] https://en.wikipedia.org/wiki/Birthday_problem

    from math import exp
    n = 618857441
    d = 2**64
    1-exp(-(n**2)/(2*d))

0.010327121831036457

D.


> So I can't bake in a limit like that, we need to keep our options open
> :)
> 
>> For btrfs, it would probably be better to stick with 64bit inode numbers
>> so that bcachefs and btrfs have similar problems and can present a joint
>> front in trying to solve them.
>>
>> (The only reason btrfs cannot use just 32bits for inode numbers is that
>>  they never re-use inode numbers.  !?!?!?! )
> 
> That is a !?!?!?. bcachefs certainly can, and it's not hard, we leave
> around an inode_generation key when we delete an inode.
> 
>> I'm against making things optional, and don't think sharding (or not
>> reusing inode numbers) is a good excuse to cause Posix incompatibility. 
>> But other than that, it makes sense.
> 
> I just don't think posix compatibility is realistically possible in all
> situations we've got coming - especially with overlayfs to consider.
> People are also starting to want to do fun things with container
> filesystems, that's becoming a hot topic as well and depending on how
> it's done the problem of combining inode numbers from multiple
> filesystems into one coherent "view" may come up again.
> 
> So I think we also need to be designing something that we know is going
> to work and relaxing our constraints a bit.

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

