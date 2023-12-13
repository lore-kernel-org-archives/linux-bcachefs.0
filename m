Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B38DB
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Dec 2023 04:43:29 -0800 (PST)
Received: from [141.14.31.7] (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 01D6461E5FE06;
	Wed, 13 Dec 2023 13:43:06 +0100 (CET)
Message-ID: <e6f2adf0-2088-4acb-8a94-b3bf38766989@molgen.mpg.de>
Date: Wed, 13 Dec 2023 13:43:05 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Content-Language: en-US
To: NeilBrown <neilb@suse.de>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Stefan Krueger <stefan.krueger@aei.mpg.de>
References: <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>
 <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
 <170199821328.12910.289120389882559143@noble.neil.brown.name>
 <20231208013739.frhvlisxut6hexnd@moria.home.lan>
 <170200162890.12910.9667703050904306180@noble.neil.brown.name>
 <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
 <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
 <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
 <170233460764.12910.276163802059260666@noble.neil.brown.name>
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <170233460764.12910.276163802059260666@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/23 23:43, NeilBrown wrote:
> On Sat, 09 Dec 2023, Kent Overstreet wrote:
>> On Fri, Dec 08, 2023 at 12:34:28PM +0100, Donald Buczek wrote:
>>> On 12/8/23 03:49, Kent Overstreet wrote:
>>>
>>>> We really only need 6 or 7 bits out of the inode number for sharding;
>>>> then 20-32 bits (nobody's going to have a billion snapshots; a million
>>>> is a more reasonable upper bound) for the subvolume ID leaves 30 to 40
>>>> bits for actually allocating inodes out of.
>>>>
>>>> That'll be enough for the vast, vast majority of users, but exceeding
>>>> that limit is already something we're technically capable of: we're
>>>> currently seeing filesystems well over 100 TB, petabyte range expected
>>>> as fsck gets more optimized and online fsck comes.
>>>
>>> 30 bits would not be enough even today:
>>>
>>> buczek@done:~$ df -i /amd/done/C/C8024
>>> Filesystem         Inodes     IUsed      IFree IUse% Mounted on
>>> /dev/md0       2187890304 618857441 1569032863   29% /amd/done/C/C8024
>>>
>>> So that's 32 bit on a random production system ( 618857441 == 0x24e303e1 ).
> 
> only 30 bits though.  So it is a long way before you use all 32 bits.
> How many volumes do you have?

Sorry, I didn't answer that and and maybe the question is obsolete. Technically, you are
correct, of  course, though the "long way" is only factor 4, I just wanted to show that
live filesystems are in the order of magnitude of 2^32 inodes.

I'm not sure, I understand the question about how many volumes or why it matters. Sure, if
we'd combine the filesystems into one, we would be way over 2^32 files.

Subvolumes: none.

Filesystems: three (100TB) filesystems like this on that particular server and additional
three 100TB filesystems on another server for the same application. A 300TB
filesystem on another server for a similar application (but much less inodes currently)

We currently have about 112 filesystems >= 100TB online, if I counted correctly, and
many, many more smaller ones (30TB, 40TB, 50TB).

Best
  Donald


>>> And if the idea to produce unique inode numbers by hashing the filehandle into 64 is followed, collisions definitely need to be addressed. With 618857441 objects, the probability of a hash collision with 64 bit is already over 1% [1].
>>
>> Oof, thanks for the data point. Yeah, 64 bits is clearly not enough for
>> a unique identifier; time to start looking at how to extend statx.
>>
> 
> 64 should be plenty...
> 
> If you have 32 bits for free allocation, and 7 bits for sharding across
> 128 CPUs, then you can allocate many more than 4 billion inodes.  Maybe
> not the full 500 billion for 39 bits, but if you actually spread the
> load over all the shards, then certainly tens of billions.
> 
> If you use 22 bits for volume number and 42 bits for inodes in a volume,
> then you can spend 7 on sharding and still have room for 55 of Donald's
> filesystems to be allocated by each CPU.
> 
> And if Donald only needs thousands of volumes, not millions, then he
> could configure for a whole lot more headroom.
> 
> In fact, if you use the 64 bits of vfs_inode number by filling in bits from
> the fs-inode number from one end, and bits from the volume number from
> the other end, then you don't need to pre-configure how the 64 bits are
> shared.
> You record inum-bits and volnum bits in the filesystem metadata, and
> increase either as needed.  Once the sum hits 64, you start returning
> ENOSPC for new files or new volumes.
> 
> There will come a day when 64 bits is not enough for inodes in a single
> filesystem.  Today is not that day.
> 
> NeilBrown

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

